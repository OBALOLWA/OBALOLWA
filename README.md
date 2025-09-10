import random

def coin_flip():
    flip = random.choice(["Heads", "Tails"])
    return flip

def main():
    print("Welcome to the Coin Flip Simulator!")
    while True:
        num_flips = input("How many times would you like to flip the coin? (or 'q' to quit): ")
        if num_flips.lower() == 'q':
            break
        try:
            num_flips = int(num_flips)
            for i in range(num_flips):
                result = coin_flip()
                print(f"Flip {i+1}: {result}")
        except ValueError:
            print("Invalid input. Please enter a number or 'q' to quit.")

if __name__ == "__main__":
    main()*/

import React, { useEffect, useMemo, useState } from "react";
import { motion, useAnimation } from "framer-motion";

export default function KalCoinDAO() {
  // --- Mock user/token state ---
  const [account, setAccount] = useState(null);
  // Mock token balances (in KAL tokens)
  const [balances, setBalances] = useState({});

  // --- Mock DAO proposals ---
  const [proposals, setProposals] = useState(() => [
    {
      id: 1,
      title: "Increase marketing budget",
      description: "Allocate 5% of treasury to marketing campaigns.",
      forVotes: 3,
      againstVotes: 1,
      executed: false,
      createdBy: "0xMockAdmin",
    },
  ]);

  const [nextProposalId, setNextProposalId] = useState(2);
  const [newProposal, setNewProposal] = useState({ title: "", description: "" });

  // --- Animation controls ---
  const controls = useAnimation();

  useEffect(() => {
    // Start a looping left-to-right coin animation
    controls.start({ x: [0, 220, -120, 0], rotate: [0, 360, 180, 0], transition: { duration: 8, repeat: Infinity, ease: "linear" } });
  }, [controls]);

  // --- Mock connect wallet ---
  function connectMockWallet() {
    // In production, replace this with wallet connect logic (e.g., MetaMask / WalletConnect)
    const mock = "0xDEADBEEF1234";
    setAccount(mock);
    // Give some mock KAL tokens to the user if not present
    setBalances((b) => ({ ...b, [mock]: (b[mock] || 100).toFixed ? (b[mock] || 100) : 100 }));
  }

  // --- DAO functions (mock) ---
  function createProposal(e) {
    e.preventDefault();
    if (!newProposal.title) return alert("Please add a title");
    const p = {
      id: nextProposalId,
      title: newProposal.title,
      description: newProposal.description,
      forVotes: 0,
      againstVotes: 0,
      executed: false,
      createdBy: account || "0xGuest",
    };
    setProposals((ps) => [p, ...ps]);
    setNextProposalId((n) => n + 1);
    setNewProposal({ title: "", description: "" });
  }

  function vote(proposalId, support) {
    if (!account) return alert("Connect wallet to vote (or use mock wallet)");
    setProposals((ps) =>
      ps.map((p) => {
        if (p.id !== proposalId) return p;
        const weight = Math.max(1, Math.floor((balances[account] || 0) / 10)); // mock voting weight
        return support ? { ...p, forVotes: p.forVotes + weight } : { ...p, againstVotes: p.againstVotes + weight };
      })
    );
  }

  function executeProposal(proposalId) {
    setProposals((ps) =>
      ps.map((p) => {
        if (p.id !== proposalId) return p;
        const passed = p.forVotes > p.againstVotes;
        return { ...p, executed: passed ? true : false };
      })
    );
  }

  // --- Utility / derived values ---
  const totalSupply = useMemo(() => {
    return Object.values(balances).reduce((s, v) => s + Number(v || 0), 0) || 1000;
  }, [balances]);

  // --- UI ---
  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-indigo-900 text-gray-100 p-6">
      <div className="max-w-6xl mx-auto">
        <header className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 relative">
              {/* Animated coin */}
              <motion.div
                className="w-16 h-16 rounded-full shadow-2xl flex items-center justify-center bg-gradient-to-b from-yellow-300 to-amber-500 text-slate-900 font-bold"
                animate={controls}
                style={{ position: "absolute" }}
              >
                KAL
              </motion.div>
            </div>

            <div>
              <h1 className="text-2xl font-extrabold">Kal Coin DAO</h1>
              <p className="text-sm text-slate-300">Community-driven DAO for Kal Coin • Twitter: <a href="https://x.com/OBALOLUWA" target="_blank" rel="noreferrer" className="underline font-medium">@OBALOLUWA</a></p>
            </div>
          </div>

          <div className="flex items-center gap-4">
            <div className="text-sm text-slate-300 text-right mr-4">
              <div>Total KAL supply</div>
              <div className="font-bold text-lg">{totalSupply.toLocaleString()} KAL</div>
            </div>

            {account ? (
              <div className="bg-slate-700 px-4 py-2 rounded-lg">
                <div className="text-xs text-slate-300">Connected</div>
                <div className="font-mono text-sm">{account}</div>
                <div className="text-xs">Balance: {(balances[account] || 0).toString()} KAL</div>
              </div>
            ) : (
              <button onClick={connectMockWallet} className="bg-amber-400 text-slate-900 px-4 py-2 rounded-lg font-semibold hover:opacity-90">Connect (mock)</button>
            )}
          </div>
        </header>

        <main className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Left - DAO actions */}
          <section className="md:col-span-2 bg-slate-800/60 rounded-2xl p-6 shadow-lg">
            <h2 className="text-xl font-bold mb-3">Proposals</h2>

            <div className="space-y-4 mb-6">
              {proposals.map((p) => (
                <div key={p.id} className={`p-4 rounded-xl border ${p.executed ? "border-emerald-500 bg-emerald-900/10" : "border-slate-700"}`}>
                  <div className="flex items-start justify-between">
                    <div>
                      <h3 className="font-semibold">#{p.id} — {p.title}</h3>
                      <p className="text-sm text-slate-300">{p.description}</p>
                      <div className="text-xs text-slate-400 mt-2">Created by: {p.createdBy}</div>
                    </div>
                    <div className="text-right">
                      <div className="text-sm">For: <span className="font-bold">{p.forVotes}</span></div>
                      <div className="text-sm">Against: <span className="font-bold">{p.againstVotes}</span></div>
                      <div className="mt-2 flex gap-2">
                        <button onClick={() => vote(p.id, true)} className="px-3 py-1 rounded-md bg-emerald-500 text-slate-900 text-sm">Vote ✅</button>
                        <button onClick={() => vote(p.id, false)} className="px-3 py-1 rounded-md bg-rose-500 text-slate-900 text-sm">Vote ❌</button>
                        <button onClick={() => executeProposal(p.id)} className="px-3 py-1 rounded-md bg-slate-700 text-sm">Execute</button>
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            <div className="mt-6 border-t border-slate-700 pt-4">
              <h3 className="font-semibold mb-2">Create new proposal</h3>
              <form onSubmit={createProposal} className="flex flex-col gap-2">
                <input className="bg-slate-900/30 rounded-md p-2" placeholder="Title" value={newProposal.title} onChange={(e) => setNewProposal((s) => ({ ...s, title: e.target.value }))} />
                <textarea className="bg-slate-900/30 rounded-md p-2" placeholder="Description" rows={3} value={newProposal.description} onChange={(e) => setNewProposal((s) => ({ ...s, description: e.target.value }))} />
                <div className="flex gap-2">
                  <button type="submit" className="bg-indigo-500 px-4 py-2 rounded-md font-semibold">Propose</button>
                  <button type="button" onClick={() => setNewProposal({ title: "", description: "" })} className="px-4 py-2 rounded-md bg-slate-700">Clear</button>
                </div>
              </form>
            </div>
          </section>

          {/* Right - Treasury / Token distribution */}
          <aside className="bg-slate-800/60 rounded-2xl p-6 shadow-lg">
            <h2 className="text-lg font-bold mb-4">Treasury & Token</h2>

            <div className="mb-4">
              <div className="text-sm text-slate-300">Your mock wallet</div>
              <div className="font-mono mt-1">{account || "Not connected"}</div>
              <div className="text-sm mt-1">Balance: <span className="font-bold">{(account && balances[account]) || 0} KAL</span></div>
            </div>

            <div className="mb-4">
              <div className="text-sm text-slate-300">Distribute mock tokens</div>
              <div className="flex gap-2 mt-2">
                <button onClick={() => {
                  const addr = account || "0xGuest";
                  setBalances((b) => ({ ...b, [addr]: (Number(b[addr] || 0) + 50) }));
                }} className="px-3 py-2 rounded-md bg-amber-400 text-slate-900 font-semibold">Mint 50 KAL to me</button>

                <button onClick={() => {
                  const addr = "0xTreasury";
                  setBalances((b) => ({ ...b, [addr]: (Number(b[addr] || 0) + 500) }));
                }} className="px-3 py-2 rounded-md bg-slate-700">Fund Treasury</button>
              </div>
            </div>

            <div>
              <h3 className="text-sm font-semibold mb-2">Holders</h3>
              <div className="space-y-2 text-sm">
                {Object.entries(balances).length === 0 ? (
                  <div className="text-slate-400">No holders yet — mint some tokens.</div>
                ) : (
                  Object.entries(balances).map(([addr, bal]) => (
                    <div key={addr} className="flex justify-between items-center">
                      <div className="font-mono text-xs">{addr}</div>
                      <div className="font-bold text-sm">{Number(bal).toLocaleString()} KAL</div>
                    </div>
                  ))
                )}
              </div>
            </div>
          </aside>
        </main>

        <footer className="mt-8 text-center text-sm text-slate-400">
          Built with ❤️ for the Kal Coin community. Follow <a href="https://x.com/OBALOLUWA" target="_blank" rel="noreferrer" className="underline">@OBALOLUWA</a> on X.
        </footer>
      </div>
    </div>
  );
}
<!doctype html>
<html lang="en-US">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="profile" href="https://gmpg.org/xfn/11">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name='robots' content='index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1' />

	<!-- This site is optimized with the Yoast SEO Premium plugin v23.9 (Yoast SEO v23.9) - https://yoast.com/wordpress/plugins/seo/ -->
	<title>Treasury and Investment - Fidelity Bank Plc | We are Fidelity</title>
	<meta name="description" content="Our expert market specialists provide our clients with high quality, quick and best execution services on Investment and treasury products." />
	<link rel="canonical" href="https://fidelitybankng.azurewebsites.net/treasury-and-investment/" />
	<meta property="og:locale" content="en_US" />
	<meta property="og:type" content="article" />
	<meta property="og:title" content="Treasury and Investment" />
	<meta property="og:description" content="Our expert market specialists provide our clients with high quality, quick and best execution services on Investment and treasury products." />
	<meta property="og:url" content="https://fidelitybankng.azurewebsites.net/treasury-and-investment/" />
	<meta property="og:site_name" content="Fidelity Bank Plc" />
	<meta property="article:publisher" content="https://www.facebook.com/FidelityBankplc" />
	<meta property="article:modified_time" content="2023-07-20T11:07:27+00:00" />
	<meta property="og:image" content="https://fidelityba856f5a3d3b.blob.core.windows.net/blobfidelityba856f5a3d3b/2020/08/fx1.jpg" />
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:site" content="@fidelitybankplc" />
	<meta name="twitter:label1" content="Est. reading time" />
	<meta name="twitter:data1" content="4 minutes" />
	<script type="application/ld+json" class="yoast-schema-graph">{"@context":"https://schema.org","@graph":[{"@type":"WebPage","@id":"https://fidelitybankng.azurewebsites.net/treasury-and-investment/","url":"https://fidelitybankng.azurewebsites.net/treasury-and-investment/","name":"Treasury and Investment - Fidelity Bank Plc | We are Fidelity","isPartOf":{"@id":"https://www.fidelitybank.ng/#website"},"primaryImageOfPage":{"@id":"https://fidelitybankng.azurewebsites.net/treasury-and-investment/#primaryimage"},"image":{"@id":"https://fidelitybankng.azurewebsites.net/treasury-and-investment/#primaryimage"},"thumbnailUrl":"https://fidelityba856f5a3d3b.blob.core.windows.net/blobfidelityba856f5a3d3b/2020/08/fx1.jpg","datePublished":"2020-08-24T10:18:26+00:00","dateModified":"2023-07-20T11:07:27+00:00","description":"Our expert market specialists provide our clients with high quality, quick and best execution services on Investment and treasury products.","breadcrumb":{"@id":"https://fidelitybankng.azurewebsites.net/treasury-and-investment/#breadcrumb"},"inLanguage":"en-US","potentialAction":[{"@type":"ReadAction","target":["https://fidelitybankng.azurewebsites.net/treasury-and-investment/"]}]},{"@type":"ImageObject","inLanguage":"en-US","@id":"https://fidelitybankng.azurewebsites.net/treasury-and-investment/#primaryimage","url":"https://fidelityba856f5a3d3b.blob.core.windows.net/blobfidelityba856f5a3d3b/2020/08/fx1.jpg","contentUrl":"https://fidelityba856f5a3d3b.blob.core.windows.net/blobfidelityba856f5a3d3b/2020/08/fx1.jpg"},{"@type":"BreadcrumbList","@id":"https://fidelitybankng.azurewebsites.net/treasury-and-investment/#breadcrumb","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://fidelitybankng.azurewebsites.net/"},{"@type":"ListItem","position":2,"name":"Treasury and Investment"}]},{"@type":"WebSite","@id":"https://www.fidelitybank.ng/#website","url":"https://www.fidelitybank.ng/","name":"Fidelity Bank Plc","description":"Banking that suits your lifestyle","publisher":{"@id":"https://www.fidelitybank.ng/#organization"},"potentialAction":[{"@type":"SearchAction","target":{"@type":"EntryPoint","urlTemplate":"https://www.fidelitybank.ng/?s={search_term_string}"},"query-input":{"@type":"PropertyValueSpecification","valueRequired":true,"valueName":"search_term_string"}}],"inLanguage":"en-US"},{"@type":"Organization","@id":"https://www.fidelitybank.ng/#organization","name":"Fidelity Bank Plc","url":"https://www.fidelitybank.ng/","logo":{"@type":"ImageObject","inLanguage":"en-US","@id":"https://www.fidelitybank.ng/#/schema/logo/image/","url":"https://migrationdiag472.blob.core.windows.net/newsite2020wpuploadfolder/2020/08/Fidelity-Bank-Logo.svg","contentUrl":"https://migrationdiag472.blob.core.windows.net/newsite2020wpuploadfolder/2020/08/Fidelity-Bank-Logo.svg","width":"1024","height":"1024","caption":"Fidelity Bank Plc"},"image":{"@id":"https://www.fidelitybank.ng/#/schema/logo/image/"},"sameAs":["https://www.facebook.com/FidelityBankplc","https://x.com/fidelitybankplc","https://instagram.com/fidelitybankplc/","https://www.linkedin.com/company/fidelitybankplc","https://www.youtube.com/channel/UCkAIpl3FNXA02ByMuW6-ILw","https://www.tiktok.com/@thefidelityfeed"]}]}</script>
	<!-- / Yoast SEO Premium plugin. -->


<link rel='dns-prefetch' href='//www.fidelitybank.ng' />
<link rel='dns-prefetch' href='//use.fontawesome.com' />
<link rel="alternate" type="application/rss+xml" title="Fidelity Bank Plc &raquo; Feed" href="https://www.fidelitybank.ng/feed/" />
<link rel="alternate" type="application/rss+xml" title="Fidelity Bank Plc &raquo; Comments Feed" href="https://www.fidelitybank.ng/comments/feed/" />
<script type="4364f5cca7525295a0b533ca-text/javascript">
window._wpemojiSettings = {"baseUrl":"https:\/\/s.w.org\/images\/core\/emoji\/15.0.3\/72x72\/","ext":".png","svgUrl":"https:\/\/s.w.org\/images\/core\/emoji\/15.0.3\/svg\/","svgExt":".svg","source":{"concatemoji":"https:\/\/www.fidelitybank.ng\/wp-includes\/js\/wp-emoji-release.min.js?ver=2d932ffafb9e30b1244520214ffca261"}};
/*! This file is auto-generated */
!function(i,n){var o,s,e;function c(e){try{var t={supportTests:e,timestamp:(new Date).valueOf()};sessionStorage.setItem(o,JSON.stringify(t))}catch(e){}}function p(e,t,n){e.clearRect(0,0,e.canvas.width,e.canvas.height),e.fillText(t,0,0);var t=new Uint32Array(e.getImageData(0,0,e.canvas.width,e.canvas.height).data),r=(e.clearRect(0,0,e.canvas.width,e.canvas.height),e.fillText(n,0,0),new Uint32Array(e.getImageData(0,0,e.canvas.width,e.canvas.height).data));return t.every(function(e,t){return e===r[t]})}function u(e,t,n){switch(t){case"flag":return n(e,"\ud83c\udff3\ufe0f\u200d\u26a7\ufe0f","\ud83c\udff3\ufe0f\u200b\u26a7\ufe0f")?!1:!n(e,"\ud83c\uddfa\ud83c\uddf3","\ud83c\uddfa\u200b\ud83c\uddf3")&&!n(e,"\ud83c\udff4\udb40\udc67\udb40\udc62\udb40\udc65\udb40\udc6e\udb40\udc67\udb40\udc7f","\ud83c\udff4\u200b\udb40\udc67\u200b\udb40\udc62\u200b\udb40\udc65\u200b\udb40\udc6e\u200b\udb40\udc67\u200b\udb40\udc7f");case"emoji":return!n(e,"\ud83d\udc26\u200d\u2b1b","\ud83d\udc26\u200b\u2b1b")}return!1}function f(e,t,n){var r="undefined"!=typeof WorkerGlobalScope&&self instanceof WorkerGlobalScope?new OffscreenCanvas(300,150):i.createElement("canvas"),a=r.getContext("2d",{willReadFrequently:!0}),o=(a.textBaseline="top",a.font="600 32px Arial",{});return e.forEach(function(e){o[e]=t(a,e,n)}),o}function t(e){var t=i.createElement("script");t.src=e,t.defer=!0,i.head.appendChild(t)}"undefined"!=typeof Promise&&(o="wpEmojiSettingsSupports",s=["flag","emoji"],n.supports={everything:!0,everythingExceptFlag:!0},e=new Promise(function(e){i.addEventListener("DOMContentLoaded",e,{once:!0})}),new Promise(function(t){var n=function(){try{var e=JSON.parse(sessionStorage.getItem(o));if("object"==typeof e&&"number"==typeof e.timestamp&&(new Date).valueOf()<e.timestamp+604800&&"object"==typeof e.supportTests)return e.supportTests}catch(e){}return null}();if(!n){if("undefined"!=typeof Worker&&"undefined"!=typeof OffscreenCanvas&&"undefined"!=typeof URL&&URL.createObjectURL&&"undefined"!=typeof Blob)try{var e="postMessage("+f.toString()+"("+[JSON.stringify(s),u.toString(),p.toString()].join(",")+"));",r=new Blob([e],{type:"text/javascript"}),a=new Worker(URL.createObjectURL(r),{name:"wpTestEmojiSupports"});return void(a.onmessage=function(e){c(n=e.data),a.terminate(),t(n)})}catch(e){}c(n=f(s,u,p))}t(n)}).then(function(e){for(var t in e)n.supports[t]=e[t],n.supports.everything=n.supports.everything&&n.supports[t],"flag"!==t&&(n.supports.everythingExceptFlag=n.supports.everythingExceptFlag&&n.supports[t]);n.supports.everythingExceptFlag=n.supports.everythingExceptFlag&&!n.supports.flag,n.DOMReady=!1,n.readyCallback=function(){n.DOMReady=!0}}).then(function(){return e}).then(function(){var e;n.supports.everything||(n.readyCallback(),(e=n.source||{}).concatemoji?t(e.concatemoji):e.wpemoji&&e.twemoji&&(t(e.twemoji),t(e.wpemoji)))}))}((window,document),window._wpemojiSettings);
</script>
<link rel='stylesheet' id='sgdg_block-css' href='/wp-content/plugins/skaut-google-drive-gallery/frontend/css/block.min.css?ver=1729155537' media='all' />
<link rel='stylesheet' id='dashicons-css' href='https://www.fidelitybank.ng/wp-includes/css/dashicons.min.css?ver=2d932ffafb9e30b1244520214ffca261' media='all' />
<link rel='stylesheet' id='elusive-css' href='/wp-content/plugins/menu-icons/vendor/codeinwp/icon-picker/css/types/elusive.min.css?ver=2.0' media='all' />
<link rel='stylesheet' id='menu-icon-font-awesome-css' href='/wp-content/plugins/menu-icons/css/fontawesome/css/all.min.css?ver=5.15.4' media='all' />
<link rel='stylesheet' id='menu-icons-extra-css' href='/wp-content/plugins/menu-icons/css/extra.min.css?ver=0.13.16' media='all' />
<style id='wp-emoji-styles-inline-css'>

	img.wp-smiley, img.emoji {
		display: inline !important;
		border: none !important;
		box-shadow: none !important;
		height: 1em !important;
		width: 1em !important;
		margin: 0 0.07em !important;
		vertical-align: -0.1em !important;
		background: none !important;
		padding: 0 !important;
	}
</style>
<style id='classic-theme-styles-inline-css'>
/*! This file is auto-generated */
.wp-block-button__link{color:#fff;background-color:#32373c;border-radius:9999px;box-shadow:none;text-decoration:none;padding:calc(.667em + 2px) calc(1.333em + 2px);font-size:1.125em}.wp-block-file__button{background:#32373c;color:#fff;text-decoration:none}
</style>
<style id='global-styles-inline-css'>
:root{--wp--preset--aspect-ratio--square: 1;--wp--preset--aspect-ratio--4-3: 4/3;--wp--preset--aspect-ratio--3-4: 3/4;--wp--preset--aspect-ratio--3-2: 3/2;--wp--preset--aspect-ratio--2-3: 2/3;--wp--preset--aspect-ratio--16-9: 16/9;--wp--preset--aspect-ratio--9-16: 9/16;--wp--preset--color--black: #000000;--wp--preset--color--cyan-bluish-gray: #abb8c3;--wp--preset--color--white: #ffffff;--wp--preset--color--pale-pink: #f78da7;--wp--preset--color--vivid-red: #cf2e2e;--wp--preset--color--luminous-vivid-orange: #ff6900;--wp--preset--color--luminous-vivid-amber: #fcb900;--wp--preset--color--light-green-cyan: #7bdcb5;--wp--preset--color--vivid-green-cyan: #00d084;--wp--preset--color--pale-cyan-blue: #8ed1fc;--wp--preset--color--vivid-cyan-blue: #0693e3;--wp--preset--color--vivid-purple: #9b51e0;--wp--preset--gradient--vivid-cyan-blue-to-vivid-purple: linear-gradient(135deg,rgba(6,147,227,1) 0%,rgb(155,81,224) 100%);--wp--preset--gradient--light-green-cyan-to-vivid-green-cyan: linear-gradient(135deg,rgb(122,220,180) 0%,rgb(0,208,130) 100%);--wp--preset--gradient--luminous-vivid-amber-to-luminous-vivid-orange: linear-gradient(135deg,rgba(252,185,0,1) 0%,rgba(255,105,0,1) 100%);--wp--preset--gradient--luminous-vivid-orange-to-vivid-red: linear-gradient(135deg,rgba(255,105,0,1) 0%,rgb(207,46,46) 100%);--wp--preset--gradient--very-light-gray-to-cyan-bluish-gray: linear-gradient(135deg,rgb(238,238,238) 0%,rgb(169,184,195) 100%);--wp--preset--gradient--cool-to-warm-spectrum: linear-gradient(135deg,rgb(74,234,220) 0%,rgb(151,120,209) 20%,rgb(207,42,186) 40%,rgb(238,44,130) 60%,rgb(251,105,98) 80%,rgb(254,248,76) 100%);--wp--preset--gradient--blush-light-purple: linear-gradient(135deg,rgb(255,206,236) 0%,rgb(152,150,240) 100%);--wp--preset--gradient--blush-bordeaux: linear-gradient(135deg,rgb(254,205,165) 0%,rgb(254,45,45) 50%,rgb(107,0,62) 100%);--wp--preset--gradient--luminous-dusk: linear-gradient(135deg,rgb(255,203,112) 0%,rgb(199,81,192) 50%,rgb(65,88,208) 100%);--wp--preset--gradient--pale-ocean: linear-gradient(135deg,rgb(255,245,203) 0%,rgb(182,227,212) 50%,rgb(51,167,181) 100%);--wp--preset--gradient--electric-grass: linear-gradient(135deg,rgb(202,248,128) 0%,rgb(113,206,126) 100%);--wp--preset--gradient--midnight: linear-gradient(135deg,rgb(2,3,129) 0%,rgb(40,116,252) 100%);--wp--preset--font-size--small: 13px;--wp--preset--font-size--medium: 20px;--wp--preset--font-size--large: 36px;--wp--preset--font-size--x-large: 42px;--wp--preset--spacing--20: 0.44rem;--wp--preset--spacing--30: 0.67rem;--wp--preset--spacing--40: 1rem;--wp--preset--spacing--50: 1.5rem;--wp--preset--spacing--60: 2.25rem;--wp--preset--spacing--70: 3.38rem;--wp--preset--spacing--80: 5.06rem;--wp--preset--shadow--natural: 6px 6px 9px rgba(0, 0, 0, 0.2);--wp--preset--shadow--deep: 12px 12px 50px rgba(0, 0, 0, 0.4);--wp--preset--shadow--sharp: 6px 6px 0px rgba(0, 0, 0, 0.2);--wp--preset--shadow--outlined: 6px 6px 0px -3px rgba(255, 255, 255, 1), 6px 6px rgba(0, 0, 0, 1);--wp--preset--shadow--crisp: 6px 6px 0px rgba(0, 0, 0, 1);}:where(.is-layout-flex){gap: 0.5em;}:where(.is-layout-grid){gap: 0.5em;}body .is-layout-flex{display: flex;}.is-layout-flex{flex-wrap: wrap;align-items: center;}.is-layout-flex > :is(*, div){margin: 0;}body .is-layout-grid{display: grid;}.is-layout-grid > :is(*, div){margin: 0;}:where(.wp-block-columns.is-layout-flex){gap: 2em;}:where(.wp-block-columns.is-layout-grid){gap: 2em;}:where(.wp-block-post-template.is-layout-flex){gap: 1.25em;}:where(.wp-block-post-template.is-layout-grid){gap: 1.25em;}.has-black-color{color: var(--wp--preset--color--black) !important;}.has-cyan-bluish-gray-color{color: var(--wp--preset--color--cyan-bluish-gray) !important;}.has-white-color{color: var(--wp--preset--color--white) !important;}.has-pale-pink-color{color: var(--wp--preset--color--pale-pink) !important;}.has-vivid-red-color{color: var(--wp--preset--color--vivid-red) !important;}.has-luminous-vivid-orange-color{color: var(--wp--preset--color--luminous-vivid-orange) !important;}.has-luminous-vivid-amber-color{color: var(--wp--preset--color--luminous-vivid-amber) !important;}.has-light-green-cyan-color{color: var(--wp--preset--color--light-green-cyan) !important;}.has-vivid-green-cyan-color{color: var(--wp--preset--color--vivid-green-cyan) !important;}.has-pale-cyan-blue-color{color: var(--wp--preset--color--pale-cyan-blue) !important;}.has-vivid-cyan-blue-color{color: var(--wp--preset--color--vivid-cyan-blue) !important;}.has-vivid-purple-color{color: var(--wp--preset--color--vivid-purple) !important;}.has-black-background-color{background-color: var(--wp--preset--color--black) !important;}.has-cyan-bluish-gray-background-color{background-color: var(--wp--preset--color--cyan-bluish-gray) !important;}.has-white-background-color{background-color: var(--wp--preset--color--white) !important;}.has-pale-pink-background-color{background-color: var(--wp--preset--color--pale-pink) !important;}.has-vivid-red-background-color{background-color: var(--wp--preset--color--vivid-red) !important;}.has-luminous-vivid-orange-background-color{background-color: var(--wp--preset--color--luminous-vivid-orange) !important;}.has-luminous-vivid-amber-background-color{background-color: var(--wp--preset--color--luminous-vivid-amber) !important;}.has-light-green-cyan-background-color{background-color: var(--wp--preset--color--light-green-cyan) !important;}.has-vivid-green-cyan-background-color{background-color: var(--wp--preset--color--vivid-green-cyan) !important;}.has-pale-cyan-blue-background-color{background-color: var(--wp--preset--color--pale-cyan-blue) !important;}.has-vivid-cyan-blue-background-color{background-color: var(--wp--preset--color--vivid-cyan-blue) !important;}.has-vivid-purple-background-color{background-color: var(--wp--preset--color--vivid-purple) !important;}.has-black-border-color{border-color: var(--wp--preset--color--black) !important;}.has-cyan-bluish-gray-border-color{border-color: var(--wp--preset--color--cyan-bluish-gray) !important;}.has-white-border-color{border-color: var(--wp--preset--color--white) !important;}.has-pale-pink-border-color{border-color: var(--wp--preset--color--pale-pink) !important;}.has-vivid-red-border-color{border-color: var(--wp--preset--color--vivid-red) !important;}.has-luminous-vivid-orange-border-color{border-color: var(--wp--preset--color--luminous-vivid-orange) !important;}.has-luminous-vivid-amber-border-color{border-color: var(--wp--preset--color--luminous-vivid-amber) !important;}.has-light-green-cyan-border-color{border-color: var(--wp--preset--color--light-green-cyan) !important;}.has-vivid-green-cyan-border-color{border-color: var(--wp--preset--color--vivid-green-cyan) !important;}.has-pale-cyan-blue-border-color{border-color: var(--wp--preset--color--pale-cyan-blue) !important;}.has-vivid-cyan-blue-border-color{border-color: var(--wp--preset--color--vivid-cyan-blue) !important;}.has-vivid-purple-border-color{border-color: var(--wp--preset--color--vivid-purple) !important;}.has-vivid-cyan-blue-to-vivid-purple-gradient-background{background: var(--wp--preset--gradient--vivid-cyan-blue-to-vivid-purple) !important;}.has-light-green-cyan-to-vivid-green-cyan-gradient-background{background: var(--wp--preset--gradient--light-green-cyan-to-vivid-green-cyan) !important;}.has-luminous-vivid-amber-to-luminous-vivid-orange-gradient-background{background: var(--wp--preset--gradient--luminous-vivid-amber-to-luminous-vivid-orange) !important;}.has-luminous-vivid-orange-to-vivid-red-gradient-background{background: var(--wp--preset--gradient--luminous-vivid-orange-to-vivid-red) !important;}.has-very-light-gray-to-cyan-bluish-gray-gradient-background{background: var(--wp--preset--gradient--very-light-gray-to-cyan-bluish-gray) !important;}.has-cool-to-warm-spectrum-gradient-background{background: var(--wp--preset--gradient--cool-to-warm-spectrum) !important;}.has-blush-light-purple-gradient-background{background: var(--wp--preset--gradient--blush-light-purple) !important;}.has-blush-bordeaux-gradient-background{background: var(--wp--preset--gradient--blush-bordeaux) !important;}.has-luminous-dusk-gradient-background{background: var(--wp--preset--gradient--luminous-dusk) !important;}.has-pale-ocean-gradient-background{background: var(--wp--preset--gradient--pale-ocean) !important;}.has-electric-grass-gradient-background{background: var(--wp--preset--gradient--electric-grass) !important;}.has-midnight-gradient-background{background: var(--wp--preset--gradient--midnight) !important;}.has-small-font-size{font-size: var(--wp--preset--font-size--small) !important;}.has-medium-font-size{font-size: var(--wp--preset--font-size--medium) !important;}.has-large-font-size{font-size: var(--wp--preset--font-size--large) !important;}.has-x-large-font-size{font-size: var(--wp--preset--font-size--x-large) !important;}
:where(.wp-block-post-template.is-layout-flex){gap: 1.25em;}:where(.wp-block-post-template.is-layout-grid){gap: 1.25em;}
:where(.wp-block-columns.is-layout-flex){gap: 2em;}:where(.wp-block-columns.is-layout-grid){gap: 2em;}
:root :where(.wp-block-pullquote){font-size: 1.5em;line-height: 1.6;}
</style>
<link rel='stylesheet' id='wpsr_main_css-css' href='/wp-content/plugins/wp-socializer/public/css/wpsr.min.css?ver=7.8' media='all' />
<link rel='stylesheet' id='wpsr_fa_icons-css' href='https://use.fontawesome.com/releases/v6.6.0/css/all.css?ver=7.8' media='all' />
<link rel='stylesheet' id='hello-elementor-css' href='/wp-content/themes/hello-elementor/style.min.css?ver=3.1.1' media='all' />
<link rel='stylesheet' id='hello-elementor-theme-style-css' href='/wp-content/themes/hello-elementor/theme.min.css?ver=3.1.1' media='all' />
<link rel='stylesheet' id='hello-elementor-header-footer-css' href='/wp-content/themes/hello-elementor/header-footer.min.css?ver=3.1.1' media='all' />
<link rel='stylesheet' id='dearpdf-style-css' href='/wp-content/plugins/dearpdf-pro/assets/css/dearpdf.min.css?ver=2.0.71' media='all' />
<link rel='stylesheet' id='elementor-frontend-css' href='/wp-content/plugins/elementor/assets/css/frontend.min.css?ver=3.25.8' media='all' />
<style id='elementor-frontend-inline-css'>
.elementor-kit-28996{--e-global-color-primary:#002082;--e-global-color-secondary:#6BC048;--e-global-color-text:#000000;--e-global-color-accent:#6BC048;--e-global-color-db9a681:#002082;--e-global-color-e4070b9:#FFFFFF;--e-global-color-f2c16ef:#FBFCFF;--e-global-typography-primary-font-family:"Open Sans";--e-global-typography-primary-font-weight:400;--e-global-typography-secondary-font-family:"Roboto";--e-global-typography-secondary-font-weight:400;--e-global-typography-text-font-family:"Open Sans";--e-global-typography-text-font-weight:400;--e-global-typography-accent-font-family:"Open Sans";--e-global-typography-accent-font-weight:500;font-family:"Open Sans", Sans-serif;font-weight:400;}.elementor-kit-28996 e-page-transition{background-color:#FFBC7D;}.elementor-kit-28996 a{color:#333333;font-family:"Open Sans", Sans-serif;}.elementor-kit-28996 a:hover{color:#002082;}.elementor-kit-28996 h1{font-family:"Open Sans", Sans-serif;}.elementor-kit-28996 h2{font-family:"Open Sans", Sans-serif;}.elementor-kit-28996 h3{font-family:"Open Sans", Sans-serif;}.elementor-kit-28996 h4{font-family:"Open Sans", Sans-serif;}.elementor-kit-28996 h5{font-family:"Open Sans", Sans-serif;}.elementor-kit-28996 h6{font-family:"Open Sans", Sans-serif;}.elementor-section.elementor-section-boxed > .elementor-container{max-width:1140px;}.e-con{--container-max-width:1140px;}.elementor-widget:not(:last-child){margin-block-end:20px;}.elementor-element{--widgets-spacing:20px 20px;}{}h1.entry-title{display:var(--page-title-display);}@media(max-width:1024px){.elementor-section.elementor-section-boxed > .elementor-container{max-width:1024px;}.e-con{--container-max-width:1024px;}}@media(max-width:767px){.elementor-section.elementor-section-boxed > .elementor-container{max-width:767px;}.e-con{--container-max-width:767px;}}
.elementor-15256 .elementor-element.elementor-element-6428c5e .elementor-repeater-item-a2237fc.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-15256 .elementor-element.elementor-element-029051d > .elementor-widget-container{margin:0px 0px 0px 0px;padding:0% 54% 0% 0%;}.elementor-15256 .elementor-element.elementor-element-029051d .elementskit-section-title-wraper .elementskit-section-title{color:#002082;margin:0px 0px 15px 0px;font-family:"Open Sans", Sans-serif;font-size:40px;font-weight:bold;}.elementor-15256 .elementor-element.elementor-element-029051d .elementskit-section-title-wraper .elementskit-section-title > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-029051d .elementskit-section-title-wraper .elementskit-section-title:hover > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-029051d .elementskit-section-title-wraper p{color:#343434;font-size:18px;}.elementor-15256 .elementor-element.elementor-element-6428c5e:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-6428c5e > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-image:url("/wp-content/uploads/2020/08/fx-1.jpg");background-position:center center;background-repeat:no-repeat;background-size:cover;}.elementor-15256 .elementor-element.elementor-element-6428c5e > .elementor-background-overlay{background-color:transparent;background-image:linear-gradient(90deg, #FFFFFF 28%, rgba(255, 255, 255, 0) 60%);opacity:0.96;transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-6428c5e > .elementor-container{min-height:435px;}.elementor-15256 .elementor-element.elementor-element-6428c5e{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;}.elementor-15256 .elementor-element.elementor-element-57f66cc .elementor-repeater-item-4aef5c2.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-15256 .elementor-element.elementor-element-1b9e76c{font-size:14px;color:#343434;}.elementor-15256 .elementor-element.elementor-element-1b9e76c a:hover{color:var( --e-global-color-accent );}.elementor-15256 .elementor-element.elementor-element-57f66cc{margin-top:20px;margin-bottom:20px;}.elementor-15256 .elementor-element.elementor-element-3aeea87 .elementor-repeater-item-ca39fb0.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-15256 .elementor-element.elementor-element-909d494 > .elementor-widget-container{margin:0px 0px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-909d494 .elementskit-section-title-wraper .elementskit-section-title{color:#002082;font-size:30px;font-weight:600;line-height:41px;}.elementor-15256 .elementor-element.elementor-element-909d494 .elementskit-section-title-wraper .elementskit-section-title > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-909d494 .elementskit-section-title-wraper .elementskit-section-title:hover > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-909d494 .elementskit-section-title-wraper .elementskit-section-subtitle{color:#343434;font-size:14px;text-transform:uppercase;}.elementor-15256 .elementor-element.elementor-element-3aeea87:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-3aeea87 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:rgba(255, 255, 255, 0.86);}.elementor-15256 .elementor-element.elementor-element-3aeea87{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:30px 0px 30px 0px;}.elementor-15256 .elementor-element.elementor-element-3aeea87 > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-381d20d .elementor-repeater-item-8c48ff1.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-15256 .elementor-element.elementor-element-c491749 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-c491749{z-index:1;}.elementor-15256 .elementor-element.elementor-element-17b0808 > .elementor-widget-container{background-color:#FBFBFB;margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-17b0808.bdt-background-overlay-yes > .elementor-widget-container:before{transition:background 0.3s;}.elementor-15256 .elementor-element.elementor-element-17b0808{text-align:left;}.elementor-15256 .elementor-element.elementor-element-ca5c81b:not(.elementor-motion-effects-element-type-background) > .elementor-widget-wrap, .elementor-15256 .elementor-element.elementor-element-ca5c81b > .elementor-widget-wrap > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FBFCFF;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-ca5c81b.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-ca5c81b.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-ca5c81b > .elementor-element-populated, .elementor-15256 .elementor-element.elementor-element-ca5c81b > .elementor-element-populated > .elementor-background-overlay, .elementor-15256 .elementor-element.elementor-element-ca5c81b > .elementor-background-slideshow{border-radius:5px 5px 5px 5px;}.elementor-15256 .elementor-element.elementor-element-ca5c81b > .elementor-element-populated{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-ca5c81b > .elementor-element-populated > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-bd5c952 > .elementor-widget-container{margin:0px 0px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-section-title{color:#002082;font-size:30px;font-weight:600;line-height:41px;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-section-title > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-section-title:hover > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-section-subtitle{color:#343434;font-size:14px;text-transform:uppercase;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-border-divider{width:60px;background:linear-gradient(90deg, #002082 0%, #002082 100%);}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-border-divider.elementskit-style-long{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-border-star{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-border-divider, .elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-border-divider::before{height:2px;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .ekit_heading_separetor_wraper{margin:20px 0px 20px 0px;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-border-divider:before{background-color:#002082;color:#002082;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-border-star:after{background-color:#002082;}.elementor-15256 .elementor-element.elementor-element-ef77a90 > .elementor-widget-container{margin:0px 40px 0px 40px;}.elementor-15256 .elementor-element.elementor-element-ef77a90 .elementor-icon-list-icon i{color:var( --e-global-color-primary );transition:color 0.3s;}.elementor-15256 .elementor-element.elementor-element-ef77a90 .elementor-icon-list-icon svg{fill:var( --e-global-color-primary );transition:fill 0.3s;}.elementor-15256 .elementor-element.elementor-element-ef77a90{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-15256 .elementor-element.elementor-element-ef77a90 .elementor-icon-list-icon{padding-right:10px;}.elementor-15256 .elementor-element.elementor-element-ef77a90 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-15256 .elementor-element.elementor-element-ef77a90 .elementor-icon-list-item > a{font-size:14px;}.elementor-15256 .elementor-element.elementor-element-ef77a90 .elementor-icon-list-text{color:#343434;transition:color 0.3s;}.elementor-15256 .elementor-element.elementor-element-93f6765 > .elementor-widget-container{margin:0px 40px 0px 55px;}.elementor-15256 .elementor-element.elementor-element-381d20d:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-381d20d > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FBFCFF;}.elementor-15256 .elementor-element.elementor-element-381d20d{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:50px 0px 50px 0px;}.elementor-15256 .elementor-element.elementor-element-381d20d > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-81b16de .elementor-repeater-item-4703f02.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-ed11565.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-ed11565.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-ed11565 > .elementor-element-populated, .elementor-15256 .elementor-element.elementor-element-ed11565 > .elementor-element-populated > .elementor-background-overlay, .elementor-15256 .elementor-element.elementor-element-ed11565 > .elementor-background-slideshow{border-radius:5px 5px 5px 5px;}.elementor-15256 .elementor-element.elementor-element-ed11565 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-d308c78 > .elementor-widget-container{margin:0px 0px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-section-title{color:#002082;font-size:30px;font-weight:600;line-height:41px;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-section-title > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-section-title:hover > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-section-subtitle{color:#343434;font-size:14px;text-transform:uppercase;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-border-divider{width:60px;background:linear-gradient(90deg, #002082 0%, #002082 100%);}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-border-divider.elementskit-style-long{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-border-star{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-border-divider, .elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-border-divider::before{height:2px;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .ekit_heading_separetor_wraper{margin:20px 0px 20px 0px;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-border-divider:before{background-color:#002082;color:#002082;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-border-star:after{background-color:#002082;}.elementor-15256 .elementor-element.elementor-element-9d4394d > .elementor-widget-container{margin:0px 50px 30px 50px;}.elementor-15256 .elementor-element.elementor-element-9d4394d{color:#343434;font-size:14px;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover{background-color:var( --e-global-color-db9a681 );}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active{background-color:var( --e-global-color-db9a681 );color:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 > .elementor-widget-container{margin:0px 50px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-accordion-icon{font-size:16px;margin-left:10px;color:#333;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg.fa-accordion-icon{height:16px;width:16px;line-height:16px;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .eael-accordion-tab-title{color:#333;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-accordion-icon-svg svg{color:#333;fill:#333;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg{fill:#333;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .eael-accordion-tab-title{color:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .fa-accordion-icon{color:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .fa-accordion-icon svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover svg.fa-accordion-icon{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .eael-accordion-tab-title{color:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-accordion-icon{color:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-accordion-icon svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active svg.fa-accordion-icon{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-content{color:#333;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle, .elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header > .fa-toggle-svg{font-size:16px;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg.fa-toggle{height:16px;width:16px;line-height:16px;fill:#444;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle{padding:0px 15px 0px 20px;color:#444;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle svg{color:#444;fill:#444;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header .fa-toggle{color:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header .fa-toggle svg{color:#FFFFFF;fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header svg.fa-toggle{fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{color:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active svg.fa-toggle{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-949c159:not(.elementor-motion-effects-element-type-background) > .elementor-widget-wrap, .elementor-15256 .elementor-element.elementor-element-949c159 > .elementor-widget-wrap > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-949c159 > .elementor-element-populated{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-949c159 > .elementor-element-populated > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-6177dd8 > .elementor-widget-container{background-color:#FBFBFB;margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-6177dd8.bdt-background-overlay-yes > .elementor-widget-container:before{transition:background 0.3s;}.elementor-15256 .elementor-element.elementor-element-6177dd8{text-align:right;}.elementor-15256 .elementor-element.elementor-element-81b16de{padding:50px 0px 50px 0px;}.elementor-15256 .elementor-element.elementor-element-6e81ff1 .elementor-repeater-item-ad18c62.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-15256 .elementor-element.elementor-element-cbf1ddd > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-cbf1ddd{z-index:1;}.elementor-15256 .elementor-element.elementor-element-c6267dd > .elementor-widget-container{background-color:#FBFBFB;margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-c6267dd.bdt-background-overlay-yes > .elementor-widget-container:before{transition:background 0.3s;}.elementor-15256 .elementor-element.elementor-element-c6267dd{text-align:left;}.elementor-15256 .elementor-element.elementor-element-1696e31:not(.elementor-motion-effects-element-type-background) > .elementor-widget-wrap, .elementor-15256 .elementor-element.elementor-element-1696e31 > .elementor-widget-wrap > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FBFCFF;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-1696e31.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-1696e31.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-1696e31 > .elementor-element-populated, .elementor-15256 .elementor-element.elementor-element-1696e31 > .elementor-element-populated > .elementor-background-overlay, .elementor-15256 .elementor-element.elementor-element-1696e31 > .elementor-background-slideshow{border-radius:5px 5px 5px 5px;}.elementor-15256 .elementor-element.elementor-element-1696e31 > .elementor-element-populated{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-1696e31 > .elementor-element-populated > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 > .elementor-widget-container{margin:0px 0px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-section-title{color:#002082;font-size:30px;font-weight:600;line-height:41px;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-section-title > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-section-title:hover > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-section-subtitle{color:#343434;font-size:14px;text-transform:uppercase;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-border-divider{width:60px;background:linear-gradient(90deg, #002082 0%, #002082 100%);}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-border-divider.elementskit-style-long{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-border-star{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-border-divider, .elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-border-divider::before{height:2px;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .ekit_heading_separetor_wraper{margin:20px 0px 20px 0px;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-border-divider:before{background-color:#002082;color:#002082;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-border-star:after{background-color:#002082;}.elementor-15256 .elementor-element.elementor-element-9bd5c15 > .elementor-widget-container{margin:0px 70px 30px 50px;}.elementor-15256 .elementor-element.elementor-element-9bd5c15{color:#343434;font-size:14px;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover{background-color:var( --e-global-color-db9a681 );}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active{background-color:var( --e-global-color-db9a681 );color:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 > .elementor-widget-container{padding:0px 50px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-accordion-icon{font-size:16px;margin-left:10px;color:#333;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg.fa-accordion-icon{height:16px;width:16px;line-height:16px;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .eael-accordion-tab-title{color:#333;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-accordion-icon-svg svg{color:#333;fill:#333;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg{fill:#333;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .eael-accordion-tab-title{color:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .fa-accordion-icon{color:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .fa-accordion-icon svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover svg.fa-accordion-icon{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .eael-accordion-tab-title{color:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-accordion-icon{color:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-accordion-icon svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active svg.fa-accordion-icon{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-content{color:#333;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle, .elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header > .fa-toggle-svg{font-size:16px;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg.fa-toggle{height:16px;width:16px;line-height:16px;fill:#444;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle{padding:0px 15px 0px 20px;color:#444;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle svg{color:#444;fill:#444;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header .fa-toggle{color:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header .fa-toggle svg{color:#FFFFFF;fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header svg.fa-toggle{fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{color:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-56b1b28 .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active svg.fa-toggle{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-6e81ff1:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-6e81ff1 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FBFCFF;}.elementor-15256 .elementor-element.elementor-element-6e81ff1{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:50px 0px 50px 0px;}.elementor-15256 .elementor-element.elementor-element-6e81ff1 > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-c14ece9 > .elementor-container > .elementor-column > .elementor-widget-wrap{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-c14ece9 .elementor-repeater-item-f674c2d.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-15256 .elementor-element.elementor-element-8b9f75f > .elementor-widget-container{margin:0px 0px 30px 0px;}.elementor-15256 .elementor-element.elementor-element-8b9f75f .elementskit-section-title-wraper .elementskit-section-title{color:#FFFFFF;margin:0px 0px 20px 0px;font-size:30px;font-weight:normal;line-height:41px;}.elementor-15256 .elementor-element.elementor-element-8b9f75f .elementskit-section-title-wraper .elementskit-section-title > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-8b9f75f .elementskit-section-title-wraper .elementskit-section-title:hover > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-8b9f75f .elementskit-section-title-wraper p{color:#FFFFFF;font-size:18px;font-weight:normal;line-height:25px;margin:0% 10% 0% 10%;}.elementor-15256 .elementor-element.elementor-element-28c7271 .elementor-button{background-color:transparent;font-size:14px;font-weight:600;line-height:15px;fill:#FFFFFF;color:#FFFFFF;background-image:linear-gradient(90deg, var( --e-global-color-accent ) 50%, #6BC04800 50%);border-radius:5px 5px 5px 5px;padding:15px 25px 15px 25px;}.elementor-15256 .elementor-element.elementor-element-28c7271 .elementor-button:hover, .elementor-15256 .elementor-element.elementor-element-28c7271 .elementor-button:focus{background-color:var( --e-global-color-accent );color:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-28c7271{z-index:2;}.elementor-15256 .elementor-element.elementor-element-28c7271 .elementor-button-content-wrapper{flex-direction:row-reverse;}.elementor-15256 .elementor-element.elementor-element-28c7271 .elementor-button .elementor-button-content-wrapper{gap:8px;}.elementor-15256 .elementor-element.elementor-element-28c7271 .elementor-button:hover svg, .elementor-15256 .elementor-element.elementor-element-28c7271 .elementor-button:focus svg{fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-c14ece9:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-c14ece9 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-image:url("/wp-content/uploads/2020/07/ir_section.jpg");}.elementor-15256 .elementor-element.elementor-element-c14ece9 > .elementor-background-overlay{background-color:#000000;opacity:0.7;transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-c14ece9{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:60px 0px 60px 0px;}.elementor-15256 .elementor-element.elementor-element-a1804a7 .elementor-repeater-item-1d7acab.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-800da90.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-800da90.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-800da90 > .elementor-element-populated, .elementor-15256 .elementor-element.elementor-element-800da90 > .elementor-element-populated > .elementor-background-overlay, .elementor-15256 .elementor-element.elementor-element-800da90 > .elementor-background-slideshow{border-radius:5px 5px 5px 5px;}.elementor-15256 .elementor-element.elementor-element-800da90 > .elementor-element-populated{margin:30px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-fe602b2 > .elementor-widget-container{margin:0px 0px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-section-title{color:#002082;font-size:30px;font-weight:600;line-height:41px;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-section-title > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-section-title:hover > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-section-subtitle{color:#343434;font-size:14px;text-transform:uppercase;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-border-divider{width:60px;background:linear-gradient(90deg, #002082 0%, #002082 100%);}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-border-divider.elementskit-style-long{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-border-star{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-border-divider, .elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-border-divider::before{height:2px;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .ekit_heading_separetor_wraper{margin:20px 0px 20px 0px;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-border-divider:before{background-color:#002082;color:#002082;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-border-star:after{background-color:#002082;}.elementor-15256 .elementor-element.elementor-element-25e1544 > .elementor-widget-container{margin:0px 70px 30px 50px;}.elementor-15256 .elementor-element.elementor-element-25e1544{color:#343434;font-size:14px;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover{background-color:var( --e-global-color-db9a681 );}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active{background-color:var( --e-global-color-db9a681 );color:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb > .elementor-widget-container{margin:0px 0px 0px 0px;padding:0px 50px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-accordion-icon{font-size:16px;margin-left:10px;color:#333;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg.fa-accordion-icon{height:16px;width:16px;line-height:16px;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header .eael-accordion-tab-title{color:#333;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-accordion-icon-svg svg{color:#333;fill:#333;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg{fill:#333;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .eael-accordion-tab-title{color:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .fa-accordion-icon{color:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .fa-accordion-icon svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover svg.fa-accordion-icon{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .eael-accordion-tab-title{color:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-accordion-icon{color:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-accordion-icon svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active svg.fa-accordion-icon{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-content{color:#333;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle, .elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header > .fa-toggle-svg{font-size:16px;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg.fa-toggle{height:16px;width:16px;line-height:16px;fill:#444;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle{padding:0px 15px 0px 20px;color:#444;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle svg{color:#444;fill:#444;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header .fa-toggle{color:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header .fa-toggle svg{color:#FFFFFF;fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header svg.fa-toggle{fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{color:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active svg.fa-toggle{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-8704545 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-65aea84 > .elementor-widget-container{background-color:#FBFBFB;margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-65aea84.bdt-background-overlay-yes > .elementor-widget-container:before{transition:background 0.3s;}.elementor-15256 .elementor-element.elementor-element-65aea84{text-align:right;}.elementor-15256 .elementor-element.elementor-element-a1804a7:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-a1804a7 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FBFCFF;}.elementor-15256 .elementor-element.elementor-element-a1804a7{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:50px 0px 50px 0px;}.elementor-15256 .elementor-element.elementor-element-a1804a7 > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-15256 .elementor-element.elementor-element-289f43c .elementor-repeater-item-432dbfd.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-15256 .elementor-element.elementor-element-ad1e393 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-ad1e393{z-index:1;}.elementor-15256 .elementor-element.elementor-element-7c0b768 > .elementor-widget-container{background-color:#FBFBFB;margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-7c0b768.bdt-background-overlay-yes > .elementor-widget-container:before{transition:background 0.3s;}.elementor-15256 .elementor-element.elementor-element-7c0b768{text-align:left;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-cae71b9.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-cae71b9.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-cae71b9 > .elementor-element-populated, .elementor-15256 .elementor-element.elementor-element-cae71b9 > .elementor-element-populated > .elementor-background-overlay, .elementor-15256 .elementor-element.elementor-element-cae71b9 > .elementor-background-slideshow{border-radius:5px 5px 5px 5px;}.elementor-15256 .elementor-element.elementor-element-cae71b9 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-915244a > .elementor-widget-container{margin:0px 0px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-section-title{color:#002082;font-size:30px;font-weight:600;line-height:41px;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-section-title > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-section-title:hover > span{color:#000000;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-section-subtitle{color:#343434;font-size:14px;text-transform:uppercase;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-border-divider{width:60px;background:linear-gradient(90deg, #002082 0%, #002082 100%);}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-border-divider.elementskit-style-long{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-border-star{width:60px;height:2px;color:#002082;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-border-divider, .elementor-15256 .elementor-element.elementor-element-915244a .elementskit-border-divider::before{height:2px;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .ekit_heading_separetor_wraper{margin:20px 0px 20px 0px;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-border-divider:before{background-color:#002082;color:#002082;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-border-star:after{background-color:#002082;}.elementor-15256 .elementor-element.elementor-element-91fece3 > .elementor-widget-container{margin:0px 0px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-91fece3{color:#343434;font-size:14px;}.elementor-15256 .elementor-element.elementor-element-5f6c27e > .elementor-widget-container{margin:0px 0px 20px 040px;}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(0px/2);}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(0px/2);}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(0px/2);margin-left:calc(0px/2);}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-0px/2);margin-left:calc(-0px/2);}body.rtl .elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-0px/2);}body:not(.rtl) .elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-0px/2);}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-icon i{color:var( --e-global-color-primary );transition:color 0.3s;}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-icon svg{fill:var( --e-global-color-primary );transition:fill 0.3s;}.elementor-15256 .elementor-element.elementor-element-5f6c27e{--e-icon-list-icon-size:17px;--icon-vertical-offset:0px;}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-icon{padding-right:0px;}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-item > .elementor-icon-list-text, .elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:14px;}.elementor-15256 .elementor-element.elementor-element-5f6c27e .elementor-icon-list-text{color:#343434;transition:color 0.3s;}.elementor-15256 .elementor-element.elementor-element-f7a56ac > .elementor-widget-container{margin:0px 70px 30px 50px;}.elementor-15256 .elementor-element.elementor-element-f7a56ac{color:#343434;font-size:14px;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover{background-color:var( --e-global-color-db9a681 );}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active{background-color:var( --e-global-color-db9a681 );color:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce > .elementor-widget-container{padding:0px 50px 0px 50px;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-accordion-icon{font-size:16px;margin-left:10px;color:#333;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg.fa-accordion-icon{height:16px;width:16px;line-height:16px;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header .eael-accordion-tab-title{color:#333;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-accordion-icon-svg svg{color:#333;fill:#333;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg{fill:#333;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .eael-accordion-tab-title{color:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .fa-accordion-icon{color:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover .fa-accordion-icon svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover svg.fa-accordion-icon{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .eael-accordion-tab-title{color:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-accordion-icon{color:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-accordion-icon svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active svg.fa-accordion-icon{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-content{color:#333;font-family:"Open Sans", Sans-serif;font-size:14px;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle, .elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header > .fa-toggle-svg{font-size:16px;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header svg.fa-toggle{height:16px;width:16px;line-height:16px;fill:#444;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle{padding:0px 15px 0px 20px;color:#444;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle svg{color:#444;fill:#444;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header .fa-toggle{color:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header .fa-toggle svg{color:#FFFFFF;fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list:hover .eael-accordion-header svg.fa-toggle{fill:#FFFFFF;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{color:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle svg{color:#fff;fill:#fff;}.elementor-15256 .elementor-element.elementor-element-2f10dce .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active svg.fa-toggle{fill:#fff;}.elementor-15256 .elementor-element.elementor-element-289f43c{padding:50px 0px 70px 0px;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(min-width:768px){.elementor-15256 .elementor-element.elementor-element-003d531{width:5%;}.elementor-15256 .elementor-element.elementor-element-8bf885f{width:88.665%;}.elementor-15256 .elementor-element.elementor-element-05c8bfe{width:5%;}.elementor-15256 .elementor-element.elementor-element-c491749{width:39.781%;}.elementor-15256 .elementor-element.elementor-element-ca5c81b{width:59.963%;}.elementor-15256 .elementor-element.elementor-element-ed11565{width:59.963%;}.elementor-15256 .elementor-element.elementor-element-949c159{width:39.781%;}.elementor-15256 .elementor-element.elementor-element-cbf1ddd{width:39.781%;}.elementor-15256 .elementor-element.elementor-element-1696e31{width:59.963%;}.elementor-15256 .elementor-element.elementor-element-800da90{width:59.963%;}.elementor-15256 .elementor-element.elementor-element-8704545{width:39.781%;}.elementor-15256 .elementor-element.elementor-element-ad1e393{width:39.781%;}.elementor-15256 .elementor-element.elementor-element-cae71b9{width:59.963%;}}@media(max-width:1024px){.elementor-15256 .elementor-element.elementor-element-029051d > .elementor-widget-container{padding:0% 35% 0% 0%;}.elementor-15256 .elementor-element.elementor-element-029051d .elementskit-section-title-wraper .elementskit-section-title{margin:0px 0px 10px 0px;font-size:36px;}.elementor-15256 .elementor-element.elementor-element-029051d .elementskit-section-title-wraper p{font-size:16px;margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-6428c5e > .elementor-container{min-height:250px;}.elementor-15256 .elementor-element.elementor-element-6428c5e:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-6428c5e > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-position:center left;background-repeat:no-repeat;background-size:cover;}.elementor-15256 .elementor-element.elementor-element-6428c5e{padding:0% 3% 0% 3%;}.elementor-15256 .elementor-element.elementor-element-57f66cc{padding:0% 3% 0% 3%;}.elementor-15256 .elementor-element.elementor-element-909d494 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-c491749.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-c491749.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-bd5c952 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-ef77a90 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-d308c78 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-9d4394d > .elementor-widget-container{margin:0px 0px 30px 0px;}.elementor-15256 .elementor-element.elementor-element-9ff2b85 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-949c159.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-949c159.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-cbf1ddd.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-cbf1ddd.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-9bd5c15 > .elementor-widget-container{margin:0px 0px 30px 0px;}.elementor-15256 .elementor-element.elementor-element-56b1b28 > .elementor-widget-container{padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-8b9f75f .elementskit-section-title-wraper .elementskit-section-title{margin:0px 0px 10px 0px;}.elementor-15256 .elementor-element.elementor-element-c14ece9{padding:3% 3% 3% 3%;}.elementor-15256 .elementor-element.elementor-element-fe602b2 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-25e1544 > .elementor-widget-container{margin:0px 0px 30px 0px;}.elementor-15256 .elementor-element.elementor-element-a2aa4bb > .elementor-widget-container{padding:0px 0px 0px 0px;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-8704545.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-8704545.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-bc-flex-widget .elementor-15256 .elementor-element.elementor-element-ad1e393.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-15256 .elementor-element.elementor-element-ad1e393.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-15256 .elementor-element.elementor-element-915244a > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-91fece3 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-5f6c27e > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-f7a56ac > .elementor-widget-container{margin:20px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-2f10dce > .elementor-widget-container{padding:0px 0px 0px 0px;}}@media(max-width:767px){.elementor-15256 .elementor-element.elementor-element-029051d > .elementor-widget-container{padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-029051d .elementskit-section-title-wraper .elementskit-section-title{font-size:24px;}.elementor-15256 .elementor-element.elementor-element-029051d .elementskit-section-title-wraper p{font-size:14px;}.elementor-15256 .elementor-element.elementor-element-6428c5e > .elementor-container{min-height:250px;}.elementor-15256 .elementor-element.elementor-element-6428c5e:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-6428c5e > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-position:-176px 0px;}.elementor-15256 .elementor-element.elementor-element-909d494 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-909d494 .elementskit-section-title-wraper .elementskit-section-title{font-size:24px;line-height:30px;}.elementor-15256 .elementor-element.elementor-element-c491749 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-17b0808 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-ca5c81b > .elementor-element-populated{margin:0px 10px 0px 10px;--e-column-margin-right:10px;--e-column-margin-left:10px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-bd5c952 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-bd5c952 .elementskit-section-title-wraper .elementskit-section-title{font-size:24px;line-height:30px;}.elementor-15256 .elementor-element.elementor-element-ef77a90 > .elementor-widget-container{margin:0px 10px 0px 0px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-93f6765 > .elementor-widget-container{margin:0px 0px 0px 35px;}.elementor-15256 .elementor-element.elementor-element-ed11565 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-15256 .elementor-element.elementor-element-d308c78 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-d308c78 .elementskit-section-title-wraper .elementskit-section-title{font-size:24px;line-height:30px;}.elementor-15256 .elementor-element.elementor-element-9d4394d > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-6177dd8 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-cbf1ddd > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-c6267dd > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-1696e31 > .elementor-element-populated{margin:0px 20px 0px 20px;--e-column-margin-right:20px;--e-column-margin-left:20px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-2bff2d0 .elementskit-section-title-wraper .elementskit-section-title{font-size:24px;line-height:30px;}.elementor-15256 .elementor-element.elementor-element-9bd5c15 > .elementor-widget-container{margin:0px 0px 30px 0px;}.elementor-15256 .elementor-element.elementor-element-8b9f75f .elementskit-section-title-wraper .elementskit-section-title{font-size:24px;line-height:30px;}.elementor-15256 .elementor-element.elementor-element-8b9f75f .elementskit-section-title-wraper p{font-size:16px;line-height:24px;margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-c14ece9:not(.elementor-motion-effects-element-type-background), .elementor-15256 .elementor-element.elementor-element-c14ece9 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-position:center center;background-repeat:no-repeat;background-size:cover;}.elementor-15256 .elementor-element.elementor-element-c14ece9{padding:60px 0px 60px 0px;}.elementor-15256 .elementor-element.elementor-element-800da90 > .elementor-element-populated{margin:0px 20px 0px 20px;--e-column-margin-right:20px;--e-column-margin-left:20px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-fe602b2 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-fe602b2 .elementskit-section-title-wraper .elementskit-section-title{font-size:24px;line-height:30px;}.elementor-15256 .elementor-element.elementor-element-25e1544 > .elementor-widget-container{margin:0px 0px 30px 0px;}.elementor-15256 .elementor-element.elementor-element-65aea84 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-ad1e393 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-7c0b768 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-cae71b9 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-915244a > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-915244a .elementskit-section-title-wraper .elementskit-section-title{font-size:24px;line-height:30px;}.elementor-15256 .elementor-element.elementor-element-91fece3 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-5f6c27e > .elementor-widget-container{margin:0px 0px 20px 0px;padding:0px 0px 0px 0px;}.elementor-15256 .elementor-element.elementor-element-f7a56ac > .elementor-widget-container{margin:0px 0px 30px 0px;}.elementor-15256 .elementor-element.elementor-element-289f43c{margin-top:0px;margin-bottom:50px;}}/* Start custom CSS for button, class: .elementor-element-28c7271 */.button-transition{
    transition: 2s;
}/* End custom CSS */
/* Start custom CSS for button, class: .elementor-element-28c7271 */.button-transition{
    transition: 2s;
}/* End custom CSS */
.elementor-9384 .elementor-element.elementor-element-48f0dd05 > .elementor-container > .elementor-column > .elementor-widget-wrap{align-content:center;align-items:center;}.elementor-9384 .elementor-element.elementor-element-48f0dd05 .elementor-repeater-item-e878d3f.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-9384 .elementor-element.elementor-element-5fc7518 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:0px;}.elementor-9384 .elementor-element.elementor-element-5fc7518 > .elementor-element-populated{box-shadow:0px 0px 32px 0px rgba(0, 0, 0, 0.1);}.elementor-9384 .elementor-element.elementor-element-5fc7518:hover > .elementor-element-populated{box-shadow:0px 0px 32px 0px rgba(0, 0, 0, 0.1);}.elementor-9384 .elementor-element.elementor-element-502e850 > .elementor-container > .elementor-column > .elementor-widget-wrap{align-content:center;align-items:center;}.elementor-9384 .elementor-element.elementor-element-502e850 .elementor-repeater-item-2984870.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-9384 .elementor-element.elementor-element-2155c0fb .elementor-button{background-color:#6CC049;font-family:"Open Sans", Sans-serif;font-size:11px;font-weight:600;text-transform:uppercase;line-height:1.5em;letter-spacing:0.5px;border-radius:5px 5px 5px 5px;box-shadow:0px 0px 27px 0px rgba(0,0,0,0.12);padding:11px 11px 11px 11px;}.elementor-9384 .elementor-element.elementor-element-2155c0fb .elementor-button:hover, .elementor-9384 .elementor-element.elementor-element-2155c0fb .elementor-button:focus{background-color:#6BCC43;}.elementor-9384 .elementor-element.elementor-element-2155c0fb > .elementor-widget-container{margin:0px 2px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-2155c0fb .elementor-button-content-wrapper{flex-direction:row-reverse;}.elementor-9384 .elementor-element.elementor-element-2155c0fb .elementor-button .elementor-button-content-wrapper{gap:4px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-container{background-color:#6BC048;height:39px;max-width:90%;border-radius:3px 3px 3px 3px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a{font-family:"Open Sans", Sans-serif;font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:0.5px;color:#FFFFFF;padding:0px 0px 0px 5px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a:hover{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a:focus{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a:active{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li:hover > a{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li:hover > a .elementskit-submenu-indicator{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a:hover .elementskit-submenu-indicator{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a:focus .elementskit-submenu-indicator{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a:active .elementskit-submenu-indicator{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li.current-menu-item > a{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li.current-menu-ancestor > a{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li.current-menu-ancestor > a .elementskit-submenu-indicator{color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a .elementskit-submenu-indicator{color:#101010;fill:#101010;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a .ekit-submenu-indicator-icon{color:#101010;fill:#101010;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel > li > a{font-size:0px;padding:0px 0px 0px 0px;color:#000000;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel > li > a:hover{color:#707070;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel > li > a:focus{color:#707070;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel > li > a:active{color:#707070;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel > li:hover > a{color:#707070;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel > li.current-menu-item > a{color:#707070 !important;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-submenu-panel{padding:15px 0px 15px 0px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel{border-radius:0px 0px 0px 0px;min-width:220px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-hamburger{float:right;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-hamburger .elementskit-menu-hamburger-icon{background-color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-hamburger > .ekit-menu-icon{color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-hamburger:hover .elementskit-menu-hamburger-icon{background-color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-hamburger:hover > .ekit-menu-icon{color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-close{color:rgba(51, 51, 51, 1);}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-close:hover{color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-1151dcc .elementor-button{background-color:#012168;font-family:"Open Sans", Sans-serif;font-size:11px;font-weight:600;text-transform:uppercase;line-height:1.5em;letter-spacing:0.5px;fill:#FFFFFF;color:#FFFFFF;border-radius:5px 5px 5px 5px;padding:11px 11px 11px 11px;}.elementor-9384 .elementor-element.elementor-element-1151dcc .elementor-button:hover, .elementor-9384 .elementor-element.elementor-element-1151dcc .elementor-button:focus{background-color:#002596;color:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-1151dcc > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-1151dcc .elementor-button:hover svg, .elementor-9384 .elementor-element.elementor-element-1151dcc .elementor-button:focus svg{fill:#FFFFFF;}.elementor-bc-flex-widget .elementor-9384 .elementor-element.elementor-element-703c7a3.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-9384 .elementor-element.elementor-element-703c7a3.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-9384 .elementor-element.elementor-element-703c7a3.elementor-column > .elementor-widget-wrap{justify-content:center;}.elementor-9384 .elementor-element.elementor-element-0b338ae > .elementor-widget-container{padding:0px 0px 0px 10px;}.elementor-9384 .elementor-element.elementor-element-0b338ae{z-index:10000;--e-nav-menu-horizontal-menu-item-margin:calc( 0px / 2 );--nav-menu-icon-size:30px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-menu-toggle{margin-right:auto;background-color:rgba(0,0,0,0);border-width:0px;border-radius:0px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu .elementor-item{font-size:12px;font-weight:600;letter-spacing:0px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main .elementor-item{color:#343434;fill:#343434;padding-left:10px;padding-right:10px;padding-top:0px;padding-bottom:0px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main .elementor-item:hover,
					.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main .elementor-item.elementor-item-active,
					.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main .elementor-item.highlighted,
					.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main .elementor-item:focus{color:#002082;fill:#002082;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main .elementor-item.elementor-item-active{color:#002082;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main:not(.elementor-nav-menu--layout-horizontal) .elementor-nav-menu > li:not(:last-child){margin-bottom:0px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a, .elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-menu-toggle{color:#343434;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown{background-color:rgba(255, 255, 255, 0.93);border-radius:0px 0px 5px 5px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a:hover,
					.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a.elementor-item-active,
					.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a.highlighted,
					.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-menu-toggle:hover{color:#002082;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a:hover,
					.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a.elementor-item-active,
					.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a.highlighted{background-color:#ededed;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a.elementor-item-active{color:#002082;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown .elementor-item, .elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown  .elementor-sub-item{font-size:11px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown li:first-child a{border-top-left-radius:0px;border-top-right-radius:0px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown li:last-child a{border-bottom-right-radius:5px;border-bottom-left-radius:5px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a{padding-left:30px;padding-right:30px;}.elementor-9384 .elementor-element.elementor-element-0b338ae div.elementor-menu-toggle{color:var( --e-global-color-secondary );}.elementor-9384 .elementor-element.elementor-element-0b338ae div.elementor-menu-toggle svg{fill:var( --e-global-color-secondary );}.elementor-9384 .elementor-element.elementor-element-c2f2670 .elementor-button{background-color:#6CC049;font-family:"Open Sans", Sans-serif;font-size:11px;font-weight:600;text-transform:uppercase;line-height:1.5em;letter-spacing:0.5px;border-radius:5px 5px 5px 5px;box-shadow:0px 0px 27px 0px rgba(0,0,0,0.12);padding:10px 10px 10px 10px;}.elementor-9384 .elementor-element.elementor-element-c2f2670 .elementor-button:hover, .elementor-9384 .elementor-element.elementor-element-c2f2670 .elementor-button:focus{background-color:#6AC844;}.elementor-9384 .elementor-element.elementor-element-c2f2670 > .elementor-widget-container{margin:0px 2px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-c2f2670 .elementor-button-content-wrapper{flex-direction:row-reverse;}.elementor-9384 .elementor-element.elementor-element-c2f2670 .elementor-button .elementor-button-content-wrapper{gap:4px;}.elementor-9384 .elementor-element.elementor-element-0365ce5 .elementor-search-form{text-align:left;}.elementor-9384 .elementor-element.elementor-element-0365ce5 .elementor-search-form__toggle{--e-search-form-toggle-size:22px;--e-search-form-toggle-color:rgba(0, 0, 0, 0.95);--e-search-form-toggle-background-color:rgba(0, 32, 130, 0);--e-search-form-toggle-border-width:0px;--e-search-form-toggle-border-radius:0px;}.elementor-9384 .elementor-element.elementor-element-0365ce5.elementor-search-form--skin-full_screen .elementor-search-form__container{background-color:rgba(0, 0, 0, 0.95);}.elementor-9384 .elementor-element.elementor-element-0365ce5 input[type="search"].elementor-search-form__input{font-family:"Open Sans", Sans-serif;font-size:50px;}.elementor-9384 .elementor-element.elementor-element-0365ce5 .elementor-search-form__input,
					.elementor-9384 .elementor-element.elementor-element-0365ce5 .elementor-search-form__icon,
					.elementor-9384 .elementor-element.elementor-element-0365ce5 .elementor-lightbox .dialog-lightbox-close-button,
					.elementor-9384 .elementor-element.elementor-element-0365ce5 .elementor-lightbox .dialog-lightbox-close-button:hover,
					.elementor-9384 .elementor-element.elementor-element-0365ce5.elementor-search-form--skin-full_screen input[type="search"].elementor-search-form__input{color:#FFFFFF;fill:#FFFFFF;}.elementor-9384 .elementor-element.elementor-element-0365ce5:not(.elementor-search-form--skin-full_screen) .elementor-search-form__container{border-radius:3px;}.elementor-9384 .elementor-element.elementor-element-0365ce5.elementor-search-form--skin-full_screen input[type="search"].elementor-search-form__input{border-radius:3px;}.elementor-9384 .elementor-element.elementor-element-2f9f8dc1 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;padding:0px 0px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-1b26ed3{text-align:right;}.elementor-9384 .elementor-element.elementor-element-1b26ed3 img{width:100%;}.elementor-9384 .elementor-element.elementor-element-502e850{padding:10px 0px 10px 0px;z-index:70000;}.elementor-9384 .elementor-element.elementor-element-1cf8ad4 > .elementor-container > .elementor-column > .elementor-widget-wrap{align-content:center;align-items:center;}.elementor-9384 .elementor-element.elementor-element-1cf8ad4 .elementor-repeater-item-888295e.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-9384 .elementor-element.elementor-element-4660595:not(.elementor-motion-effects-element-type-background) > .elementor-widget-wrap, .elementor-9384 .elementor-element.elementor-element-4660595 > .elementor-widget-wrap > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FAFAFA;}.elementor-bc-flex-widget .elementor-9384 .elementor-element.elementor-element-4660595.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-9384 .elementor-element.elementor-element-4660595.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-9384 .elementor-element.elementor-element-4660595.elementor-column > .elementor-widget-wrap{justify-content:center;}.elementor-9384 .elementor-element.elementor-element-4660595 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:0px;}.elementor-9384 .elementor-element.elementor-element-4660595 > .elementor-element-populated{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;}.elementor-9384 .elementor-element.elementor-element-4660595 > .elementor-element-populated > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-container{height:30px;border-radius:0px 0px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a{font-size:12px;font-weight:600;color:#343434;padding:0px 15px 0px 15px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a:hover{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a:focus{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a:active{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li:hover > a{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li:hover > a .elementskit-submenu-indicator{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a:hover .elementskit-submenu-indicator{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a:focus .elementskit-submenu-indicator{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a:active .elementskit-submenu-indicator{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li.current-menu-item > a{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li.current-menu-ancestor > a{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li.current-menu-ancestor > a .elementskit-submenu-indicator{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a .elementskit-submenu-indicator{color:#101010;fill:#101010;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a .ekit-submenu-indicator-icon{color:#101010;fill:#101010;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel > li > a{font-family:"Open Sans", Sans-serif;font-weight:bold;padding:15px 15px 15px 15px;color:#000000;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel > li > a:hover{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel > li > a:focus{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel > li > a:active{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel > li:hover > a{color:#002082;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel > li.current-menu-item > a{color:#002082 !important;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-submenu-panel{padding:15px 0px 15px 0px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel{border-radius:0px 0px 0px 0px;min-width:220px;box-shadow:0px 0px 10px 0px rgba(10, 10, 10, 0.5);}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-hamburger{float:right;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-hamburger .elementskit-menu-hamburger-icon{background-color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-hamburger > .ekit-menu-icon{color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-hamburger:hover .elementskit-menu-hamburger-icon{background-color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-hamburger:hover > .ekit-menu-icon{color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-close{color:rgba(51, 51, 51, 1);}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-close:hover{color:rgba(0, 0, 0, 0.5);}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu .elementor-item{font-size:12px;font-weight:600;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main .elementor-item{color:#343434;fill:#343434;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main .elementor-item:hover,
					.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main .elementor-item.elementor-item-active,
					.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main .elementor-item.highlighted,
					.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main .elementor-item:focus{color:#002082;fill:#002082;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main:not(.e--pointer-framed) .elementor-item:before,
					.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main:not(.e--pointer-framed) .elementor-item:after{background-color:#002082;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed .elementor-item:before,
					.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed .elementor-item:after{border-color:#002082;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main .elementor-item.elementor-item-active{color:#002082;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main:not(.e--pointer-framed) .elementor-item.elementor-item-active:before,
					.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main:not(.e--pointer-framed) .elementor-item.elementor-item-active:after{background-color:var( --e-global-color-primary );}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed .elementor-item.elementor-item-active:before,
					.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed .elementor-item.elementor-item-active:after{border-color:var( --e-global-color-primary );}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--dropdown{background-color:#FFFFFFEB;}.elementor-9384 .elementor-element.elementor-element-1cf8ad4:not(.elementor-motion-effects-element-type-background), .elementor-9384 .elementor-element.elementor-element-1cf8ad4 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FAFAFA;}.elementor-9384 .elementor-element.elementor-element-1cf8ad4{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;z-index:60000;}.elementor-9384 .elementor-element.elementor-element-1cf8ad4 > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-9384 .elementor-element.elementor-element-48f0dd05:not(.elementor-motion-effects-element-type-background), .elementor-9384 .elementor-element.elementor-element-48f0dd05 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#ffffff;}.elementor-9384 .elementor-element.elementor-element-48f0dd05 > .elementor-container{min-height:0px;}.elementor-9384 .elementor-element.elementor-element-48f0dd05{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;z-index:60000;}.elementor-9384 .elementor-element.elementor-element-48f0dd05 > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-theme-builder-content-area{height:400px;}.elementor-location-header:before, .elementor-location-footer:before{content:"";display:table;clear:both;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(min-width:768px){.elementor-9384 .elementor-element.elementor-element-fa799f9{width:13%;}.elementor-9384 .elementor-element.elementor-element-38b914e{width:13%;}.elementor-9384 .elementor-element.elementor-element-703c7a3{width:50%;}.elementor-9384 .elementor-element.elementor-element-1809624d{width:2.427%;}.elementor-9384 .elementor-element.elementor-element-8dcfbc3{width:3%;}.elementor-9384 .elementor-element.elementor-element-2f9f8dc1{width:17.233%;}}@media(max-width:1024px) and (min-width:768px){.elementor-9384 .elementor-element.elementor-element-5fc7518{width:100%;}.elementor-9384 .elementor-element.elementor-element-fa799f9{width:21%;}.elementor-9384 .elementor-element.elementor-element-38b914e{width:19%;}.elementor-9384 .elementor-element.elementor-element-703c7a3{width:35%;}.elementor-9384 .elementor-element.elementor-element-8dcfbc3{width:2%;}.elementor-9384 .elementor-element.elementor-element-2f9f8dc1{width:21%;}}@media(max-width:1024px){.elementor-bc-flex-widget .elementor-9384 .elementor-element.elementor-element-5fc7518.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-9384 .elementor-element.elementor-element-5fc7518.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-9384 .elementor-element.elementor-element-5fc7518.elementor-column > .elementor-widget-wrap{justify-content:center;}.elementor-9384 .elementor-element.elementor-element-5fc7518 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:0px;}.elementor-9384 .elementor-element.elementor-element-2155c0fb .elementor-button{font-size:11px;padding:11px 11px 11px 11px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-nav-identity-panel{padding:10px 0px 10px 0px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-container{max-width:95%;border-radius:0px 0px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav > li > a{color:#FFFFFF;padding:10px 15px 10px 15px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel > li > a{padding:15px 15px 15px 15px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-navbar-nav .elementskit-submenu-panel{border-radius:0px 0px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-hamburger{padding:8px 8px 8px 8px;width:45px;border-radius:3px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-menu-close{padding:8px 8px 8px 8px;margin:12px 12px 12px 12px;width:45px;border-radius:3px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-nav-logo > img{max-width:160px;max-height:60px;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-nav-logo{margin:5px 0px 5px 0px;padding:5px 5px 5px 5px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu .elementor-item{font-size:11px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main .elementor-item{padding-left:5px;padding-right:5px;}.elementor-9384 .elementor-element.elementor-element-0b338ae{--e-nav-menu-horizontal-menu-item-margin:calc( 0px / 2 );}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main:not(.elementor-nav-menu--layout-horizontal) .elementor-nav-menu > li:not(:last-child){margin-bottom:0px;}.elementor-9384 .elementor-element.elementor-element-1b26ed3 img{max-width:82%;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-nav-identity-panel{padding:10px 0px 10px 0px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-container{max-width:350px;border-radius:0px 0px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav > li > a{color:#000000;padding:10px 15px 10px 15px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel > li > a{padding:15px 15px 15px 15px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-navbar-nav .elementskit-submenu-panel{border-radius:0px 0px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-hamburger{padding:8px 8px 8px 8px;width:45px;border-radius:3px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-menu-close{padding:8px 8px 8px 8px;margin:12px 12px 12px 12px;width:45px;border-radius:3px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-nav-logo > img{max-width:160px;max-height:60px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-nav-logo{margin:5px 0px 5px 0px;padding:5px 5px 5px 5px;}.elementor-9384 .elementor-element.elementor-element-48f0dd05{padding:0px 0px 0px 0px;}}@media(max-width:767px){.elementor-9384 .elementor-element.elementor-element-5fc7518{width:100%;}.elementor-9384 .elementor-element.elementor-element-fa799f9{width:50%;}.elementor-9384 .elementor-element.elementor-element-efbe71a .elementskit-nav-logo > img{max-width:120px;max-height:50px;}.elementor-9384 .elementor-element.elementor-element-38b914e{width:50%;}.elementor-9384 .elementor-element.elementor-element-703c7a3{width:15%;}.elementor-bc-flex-widget .elementor-9384 .elementor-element.elementor-element-703c7a3.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-9384 .elementor-element.elementor-element-703c7a3.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-9384 .elementor-element.elementor-element-703c7a3.elementor-column > .elementor-widget-wrap{justify-content:center;}.elementor-9384 .elementor-element.elementor-element-703c7a3 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--dropdown a{padding-top:12px;padding-bottom:12px;}.elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu--main > .elementor-nav-menu > li > .elementor-nav-menu--dropdown, .elementor-9384 .elementor-element.elementor-element-0b338ae .elementor-nav-menu__container.elementor-nav-menu--dropdown{margin-top:20px !important;}.elementor-9384 .elementor-element.elementor-element-0b338ae{--nav-menu-icon-size:20px;}.elementor-9384 .elementor-element.elementor-element-1809624d{width:24%;}.elementor-bc-flex-widget .elementor-9384 .elementor-element.elementor-element-1809624d.elementor-column .elementor-widget-wrap{align-items:center;}.elementor-9384 .elementor-element.elementor-element-1809624d.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:center;align-items:center;}.elementor-9384 .elementor-element.elementor-element-1809624d.elementor-column > .elementor-widget-wrap{justify-content:center;}.elementor-9384 .elementor-element.elementor-element-1809624d > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-9384 .elementor-element.elementor-element-8dcfbc3{width:16%;}.elementor-9384 .elementor-element.elementor-element-8dcfbc3 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-9384 .elementor-element.elementor-element-2f9f8dc1{width:41%;}.elementor-9384 .elementor-element.elementor-element-2f9f8dc1 > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-9384 .elementor-element.elementor-element-1b26ed3 img{max-width:82%;}.elementor-9384 .elementor-element.elementor-element-502e850{margin-top:0px;margin-bottom:0px;}.elementor-9384 .elementor-element.elementor-element-abf0dde .elementskit-nav-logo > img{max-width:120px;max-height:50px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 > .elementor-widget-container{padding:0px 0px 0px 0px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu .elementor-item{font-size:11px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed .elementor-item:before{border-width:1px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed.e--animation-draw .elementor-item:before{border-width:0 0 1px 1px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed.e--animation-draw .elementor-item:after{border-width:1px 1px 0 0;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed.e--animation-corners .elementor-item:before{border-width:1px 0 0 1px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-framed.e--animation-corners .elementor-item:after{border-width:0 1px 1px 0;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-underline .elementor-item:after,
					 .elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-overline .elementor-item:before,
					 .elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-double-line .elementor-item:before,
					 .elementor-9384 .elementor-element.elementor-element-d8aa2c3 .e--pointer-double-line .elementor-item:after{height:1px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main .elementor-item{padding-left:10px;padding-right:10px;padding-top:5px;padding-bottom:5px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3{--e-nav-menu-horizontal-menu-item-margin:calc( 0px / 2 );}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--main:not(.elementor-nav-menu--layout-horizontal) .elementor-nav-menu > li:not(:last-child){margin-bottom:0px;}.elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--dropdown .elementor-item, .elementor-9384 .elementor-element.elementor-element-d8aa2c3 .elementor-nav-menu--dropdown  .elementor-sub-item{font-size:12px;}.elementor-9384 .elementor-element.elementor-element-48f0dd05{padding:0px 0px 0px 0px;}}/* Start custom CSS for ekit-nav-menu, class: .elementor-element-efbe71a */.elementskit-navbar-nav-default .elementskit-dropdown-has>a .elementskit-submenu-indicator {
    display: none !important;
}/* End custom CSS */
/* Start custom CSS for ekit-nav-menu, class: .elementor-element-efbe71a */.elementskit-navbar-nav-default .elementskit-dropdown-has>a .elementskit-submenu-indicator {
    display: none !important;
}/* End custom CSS */
/* Start custom CSS for ekit-nav-menu, class: .elementor-element-efbe71a */.elementskit-navbar-nav-default .elementskit-dropdown-has>a .elementskit-submenu-indicator {
    display: none !important;
}/* End custom CSS */
/* Start custom CSS for ekit-nav-menu, class: .elementor-element-efbe71a */.elementskit-navbar-nav-default .elementskit-dropdown-has>a .elementskit-submenu-indicator {
    display: none !important;
}/* End custom CSS */
.elementor-9695 .elementor-element.elementor-element-24cb887 > .elementor-container > .elementor-column > .elementor-widget-wrap{align-content:center;align-items:center;}.elementor-9695 .elementor-element.elementor-element-24cb887 .elementor-repeater-item-418a267.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-9695 .elementor-element.elementor-element-a24103a .elementor-heading-title{color:#FFFFFF;font-family:"Open Sans", Sans-serif;font-size:30px;font-weight:600;}.elementor-9695 .elementor-element.elementor-element-f3a46eb .elementor-button{background-color:transparent;font-size:16px;fill:#FFFFFF;color:#FFFFFF;background-image:linear-gradient(90deg, var( --e-global-color-accent ) 50%, #6BC04800 50%);border-radius:5px 5px 5px 5px;padding:15px 25px 15px 25px;}.elementor-9695 .elementor-element.elementor-element-f3a46eb .elementor-button:hover, .elementor-9695 .elementor-element.elementor-element-f3a46eb .elementor-button:focus{background-color:var( --e-global-color-accent );color:#F5F5F5;}.elementor-9695 .elementor-element.elementor-element-f3a46eb.bdt-background-overlay-yes > .elementor-widget-container:before{transition:background 0.3s;}.elementor-9695 .elementor-element.elementor-element-f3a46eb .elementor-button-content-wrapper{flex-direction:row-reverse;}.elementor-9695 .elementor-element.elementor-element-f3a46eb .elementor-button:hover svg, .elementor-9695 .elementor-element.elementor-element-f3a46eb .elementor-button:focus svg{fill:#F5F5F5;}.elementor-9695 .elementor-element.elementor-element-24cb887:not(.elementor-motion-effects-element-type-background), .elementor-9695 .elementor-element.elementor-element-24cb887 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-image:url("https://migrationdiag472.blob.core.windows.net/newsite2020wpuploadfolder/2020/10/contact-us.jpg");background-position:center center;background-repeat:no-repeat;background-size:cover;}.elementor-9695 .elementor-element.elementor-element-24cb887 > .elementor-background-overlay{background-color:#002082;opacity:0.77;mix-blend-mode:multiply;transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-9695 .elementor-element.elementor-element-24cb887 > .elementor-container{min-height:150px;}.elementor-9695 .elementor-element.elementor-element-24cb887 .elementor-background-overlay{filter:brightness( 100% ) contrast( 100% ) saturate( 100% ) blur( 0px ) hue-rotate( 0deg );}.elementor-9695 .elementor-element.elementor-element-24cb887{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;margin-top:0px;margin-bottom:0px;}.elementor-9695 .elementor-element.elementor-element-c56420b .elementor-repeater-item-9aec421.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-bc-flex-widget .elementor-9695 .elementor-element.elementor-element-66a0dc8.elementor-column .elementor-widget-wrap{align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-66a0dc8.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:flex-start;align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-85ee164 > .elementor-widget-container{margin:0px 0px 15px 0px;}.elementor-9695 .elementor-element.elementor-element-85ee164{text-align:left;}.elementor-9695 .elementor-element.elementor-element-85ee164 .elementor-heading-title{color:#666666;font-family:"Open Sans", Sans-serif;font-size:14px;font-weight:600;}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(6px/2);margin-left:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-6px/2);margin-left:calc(-6px/2);}body.rtl .elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-6px/2);}body:not(.rtl) .elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-6px/2);}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-9695 .elementor-element.elementor-element-168ac7e{--e-icon-list-icon-size:0px;--icon-vertical-offset:0px;}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-icon{padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:13px;font-weight:400;line-height:19px;}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-bc-flex-widget .elementor-9695 .elementor-element.elementor-element-76fe43c.elementor-column .elementor-widget-wrap{align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-76fe43c.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:flex-start;align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-0eed5ad > .elementor-widget-container{margin:0px 0px 15px 0px;}.elementor-9695 .elementor-element.elementor-element-0eed5ad{text-align:left;}.elementor-9695 .elementor-element.elementor-element-0eed5ad .elementor-heading-title{color:#666666;font-family:"Open Sans", Sans-serif;font-size:14px;font-weight:600;}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(6px/2);margin-left:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-6px/2);margin-left:calc(-6px/2);}body.rtl .elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-6px/2);}body:not(.rtl) .elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-6px/2);}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-9695 .elementor-element.elementor-element-5e977c4{--e-icon-list-icon-size:0px;--icon-vertical-offset:0px;}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-icon{padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:13px;font-weight:400;line-height:19px;}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-bc-flex-widget .elementor-9695 .elementor-element.elementor-element-5f7df81.elementor-column .elementor-widget-wrap{align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-5f7df81.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:flex-start;align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-1150f82 > .elementor-widget-container{margin:0px 0px 15px 0px;}.elementor-9695 .elementor-element.elementor-element-1150f82{text-align:left;}.elementor-9695 .elementor-element.elementor-element-1150f82 .elementor-heading-title{color:#666666;font-family:"Open Sans", Sans-serif;font-size:14px;font-weight:600;}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(6px/2);margin-left:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-6px/2);margin-left:calc(-6px/2);}body.rtl .elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-6px/2);}body:not(.rtl) .elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-6px/2);}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-9695 .elementor-element.elementor-element-f74ff97{--e-icon-list-icon-size:0px;--icon-vertical-offset:0px;}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-icon{padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:13px;font-weight:400;line-height:19px;}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-bc-flex-widget .elementor-9695 .elementor-element.elementor-element-1d6477f.elementor-column .elementor-widget-wrap{align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-1d6477f.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:flex-start;align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-68c94b0 > .elementor-widget-container{margin:0px 0px 15px 0px;}.elementor-9695 .elementor-element.elementor-element-68c94b0{text-align:left;}.elementor-9695 .elementor-element.elementor-element-68c94b0 .elementor-heading-title{color:#666666;font-family:"Open Sans", Sans-serif;font-size:14px;font-weight:600;}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(6px/2);margin-left:calc(6px/2);}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-6px/2);margin-left:calc(-6px/2);}body.rtl .elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-6px/2);}body:not(.rtl) .elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-6px/2);}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-9695 .elementor-element.elementor-element-a84b55b{--e-icon-list-icon-size:0px;--icon-vertical-offset:0px;}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-icon{padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:13px;font-weight:400;line-height:19px;}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-bc-flex-widget .elementor-9695 .elementor-element.elementor-element-deadc23.elementor-column .elementor-widget-wrap{align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-deadc23.elementor-column.elementor-element[data-element_type="column"] > .elementor-widget-wrap.elementor-element-populated{align-content:flex-start;align-items:flex-start;}.elementor-9695 .elementor-element.elementor-element-efd70b3 > .elementor-widget-container{margin:0px 0px 16px 0px;}.elementor-9695 .elementor-element.elementor-element-efd70b3{text-align:left;}.elementor-9695 .elementor-element.elementor-element-efd70b3 .elementor-heading-title{color:#666666;font-family:"Open Sans", Sans-serif;font-size:14px;font-weight:600;}.elementor-9695 .elementor-element.elementor-element-de1109d{--display:flex;--flex-direction:row;--container-widget-width:calc( ( 1 - var( --container-widget-flex-grow ) ) * 100% );--container-widget-height:100%;--container-widget-flex-grow:1;--container-widget-align-self:stretch;--flex-wrap-mobile:wrap;--align-items:stretch;--gap:0px 0px;--background-transition:0.3s;--margin-top:0px;--margin-bottom:10px;--margin-left:0px;--margin-right:0px;--padding-top:0px;--padding-bottom:0px;--padding-left:0px;--padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-643c0aa{--display:flex;--flex-direction:row;--container-widget-width:initial;--container-widget-height:100%;--container-widget-flex-grow:1;--container-widget-align-self:stretch;--flex-wrap-mobile:wrap;--gap:10px 10px;--background-transition:0.3s;--padding-top:0px;--padding-bottom:0px;--padding-left:0px;--padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-1f79894{text-align:left;}.elementor-9695 .elementor-element.elementor-element-1f79894 img{width:100%;}.elementor-9695 .elementor-element.elementor-element-97a959d{text-align:left;}.elementor-9695 .elementor-element.elementor-element-97a959d img{width:100%;}.elementor-9695 .elementor-element.elementor-element-f6f9b8f{--display:flex;--flex-direction:row;--container-widget-width:calc( ( 1 - var( --container-widget-flex-grow ) ) * 100% );--container-widget-height:100%;--container-widget-flex-grow:1;--container-widget-align-self:stretch;--flex-wrap-mobile:wrap;--align-items:stretch;--gap:0px 0px;--background-transition:0.3s;--margin-top:0px;--margin-bottom:10px;--margin-left:0px;--margin-right:0px;--padding-top:0px;--padding-bottom:0px;--padding-left:0px;--padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-e29cc10{--display:flex;--flex-direction:row;--container-widget-width:initial;--container-widget-height:100%;--container-widget-flex-grow:1;--container-widget-align-self:stretch;--flex-wrap-mobile:wrap;--gap:10px 10px;--background-transition:0.3s;--padding-top:0px;--padding-bottom:0px;--padding-left:0px;--padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-8cc32b3{text-align:left;}.elementor-9695 .elementor-element.elementor-element-8cc32b3 img{width:100%;}.elementor-9695 .elementor-element.elementor-element-3ab83ea{text-align:left;}.elementor-9695 .elementor-element.elementor-element-3ab83ea img{width:100%;}.elementor-9695 .elementor-element.elementor-element-c56420b:not(.elementor-motion-effects-element-type-background), .elementor-9695 .elementor-element.elementor-element-c56420b > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FAFAFA;}.elementor-9695 .elementor-element.elementor-element-c56420b{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:40px 0px 10px 0px;}.elementor-9695 .elementor-element.elementor-element-c56420b > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-9695 .elementor-element.elementor-element-1e955e6{--display:flex;--min-height:50px;--flex-direction:row;--container-widget-width:calc( ( 1 - var( --container-widget-flex-grow ) ) * 100% );--container-widget-height:100%;--container-widget-flex-grow:1;--container-widget-align-self:stretch;--flex-wrap-mobile:wrap;--align-items:stretch;--gap:10px 10px;--background-transition:0.3s;border-style:solid;--border-style:solid;border-width:1px 0px 0px 0px;--border-top-width:1px;--border-right-width:0px;--border-bottom-width:0px;--border-left-width:0px;border-color:rgba(255,255,255,0.19);--border-color:rgba(255,255,255,0.19);--padding-top:0px;--padding-bottom:70px;--padding-left:0px;--padding-right:0px;}.elementor-9695 .elementor-element.elementor-element-1e955e6:not(.elementor-motion-effects-element-type-background), .elementor-9695 .elementor-element.elementor-element-1e955e6 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FAFAFA;}.elementor-9695 .elementor-element.elementor-element-1e955e6 .elementor-repeater-item-fe07aa9.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-9695 .elementor-element.elementor-element-bbc72b1{--display:flex;--flex-direction:row;--container-widget-width:calc( ( 1 - var( --container-widget-flex-grow ) ) * 100% );--container-widget-height:100%;--container-widget-flex-grow:1;--container-widget-align-self:stretch;--flex-wrap-mobile:wrap;--justify-content:space-between;--align-items:flex-start;--background-transition:0.3s;}.elementor-9695 .elementor-element.elementor-element-bbc72b1.e-con{--flex-grow:0;--flex-shrink:0;}.elementor-9695 .elementor-element.elementor-element-3d6beb3{width:var( --container-widget-width, 43% );max-width:43%;--container-widget-width:43%;--container-widget-flex-grow:0;text-align:left;color:#666666;font-family:"Open Sans", Sans-serif;font-size:13px;font-weight:400;}.elementor-9695 .elementor-element.elementor-element-a7c0504{text-align:right;color:#666666;font-family:"Open Sans", Sans-serif;font-size:13px;font-weight:400;}.elementor-9695 .elementor-element.elementor-element-1e955e6, .elementor-9695 .elementor-element.elementor-element-1e955e6::before{--border-transition:0.3s;}.elementor-theme-builder-content-area{height:400px;}.elementor-location-header:before, .elementor-location-footer:before{content:"";display:table;clear:both;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(max-width:1024px){.elementor-9695 .elementor-element.elementor-element-24cb887{padding:0px 30px 0px 30px;}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-item > a{font-size:13px;}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-item > a{font-size:13px;}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-item > a{font-size:13px;}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-item > a{font-size:13px;}.elementor-9695 .elementor-element.elementor-element-c56420b{padding:50px 20px 0px 20px;}.elementor-9695 .elementor-element.elementor-element-bbc72b1{--flex-direction:column;--container-widget-width:calc( ( 1 - var( --container-widget-flex-grow ) ) * 100% );--container-widget-height:initial;--container-widget-flex-grow:0;--container-widget-align-self:initial;--flex-wrap-mobile:wrap;--align-items:center;--gap:0px 0px;}.elementor-9695 .elementor-element.elementor-element-3d6beb3{--container-widget-width:100%;--container-widget-flex-grow:0;width:var( --container-widget-width, 100% );max-width:100%;text-align:center;}.elementor-9695 .elementor-element.elementor-element-a7c0504 > .elementor-widget-container{margin:-7px 0px 0px 0px;}.elementor-9695 .elementor-element.elementor-element-a7c0504{text-align:right;}.elementor-9695 .elementor-element.elementor-element-1e955e6{--flex-direction:column;--container-widget-width:calc( ( 1 - var( --container-widget-flex-grow ) ) * 100% );--container-widget-height:initial;--container-widget-flex-grow:0;--container-widget-align-self:initial;--flex-wrap-mobile:wrap;--align-items:stretch;--padding-top:10px;--padding-bottom:10px;--padding-left:20px;--padding-right:20px;}}@media(max-width:767px){.elementor-9695 .elementor-element.elementor-element-a24103a{text-align:center;}.elementor-9695 .elementor-element.elementor-element-a24103a .elementor-heading-title{font-size:21px;line-height:26px;}.elementor-9695 .elementor-element.elementor-element-24cb887{padding:0px 0px 0px 0px;}.elementor-9695 .elementor-element.elementor-element-66a0dc8{width:50%;}.elementor-9695 .elementor-element.elementor-element-66a0dc8 > .elementor-element-populated{margin:0px 0px 30px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;padding:0px 0px 0px 0px;}.elementor-9695 .elementor-element.elementor-element-85ee164{text-align:left;}.elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-168ac7e .elementor-icon-list-item > a{font-size:13px;}.elementor-9695 .elementor-element.elementor-element-76fe43c{width:50%;}.elementor-9695 .elementor-element.elementor-element-76fe43c > .elementor-element-populated{padding:0px 0px 0px 20px;}.elementor-9695 .elementor-element.elementor-element-0eed5ad{text-align:left;}.elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-5e977c4 .elementor-icon-list-item > a{font-size:13px;}.elementor-9695 .elementor-element.elementor-element-5f7df81{width:50%;}.elementor-9695 .elementor-element.elementor-element-5f7df81 > .elementor-element-populated{margin:0px 0px 30px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;padding:0px 0px 0px 0px;}.elementor-9695 .elementor-element.elementor-element-1150f82{text-align:left;}.elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-f74ff97 .elementor-icon-list-item > a{font-size:13px;}.elementor-9695 .elementor-element.elementor-element-1d6477f{width:50%;}.elementor-9695 .elementor-element.elementor-element-1d6477f > .elementor-element-populated{padding:0px 0px 0px 20px;}.elementor-9695 .elementor-element.elementor-element-68c94b0{text-align:left;}.elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-item > .elementor-icon-list-text, .elementor-9695 .elementor-element.elementor-element-a84b55b .elementor-icon-list-item > a{font-size:13px;}.elementor-9695 .elementor-element.elementor-element-deadc23{width:100%;}.elementor-9695 .elementor-element.elementor-element-deadc23 > .elementor-element-populated{padding:0px 0px 0px 0px;}.elementor-9695 .elementor-element.elementor-element-efd70b3{text-align:left;}.elementor-9695 .elementor-element.elementor-element-643c0aa{--width:100%;--gap:12px 12px;--margin-top:0px;--margin-bottom:0px;--margin-left:0px;--margin-right:0px;}.elementor-9695 .elementor-element.elementor-element-1f79894{width:var( --container-widget-width, 48% );max-width:48%;--container-widget-width:48%;--container-widget-flex-grow:0;}.elementor-9695 .elementor-element.elementor-element-1f79894 img{width:100%;}.elementor-9695 .elementor-element.elementor-element-97a959d{width:var( --container-widget-width, 48% );max-width:48%;--container-widget-width:48%;--container-widget-flex-grow:0;}.elementor-9695 .elementor-element.elementor-element-97a959d img{width:100%;}.elementor-9695 .elementor-element.elementor-element-e29cc10{--width:100%;--gap:12px 12px;--margin-top:0px;--margin-bottom:0px;--margin-left:0px;--margin-right:0px;}.elementor-9695 .elementor-element.elementor-element-8cc32b3{width:var( --container-widget-width, 48% );max-width:48%;--container-widget-width:48%;--container-widget-flex-grow:0;}.elementor-9695 .elementor-element.elementor-element-8cc32b3 img{width:100%;}.elementor-9695 .elementor-element.elementor-element-3ab83ea{width:var( --container-widget-width, 48% );max-width:48%;--container-widget-width:48%;--container-widget-flex-grow:0;}.elementor-9695 .elementor-element.elementor-element-3ab83ea img{width:100%;}.elementor-9695 .elementor-element.elementor-element-c56420b{padding:35px 20px 35px 20px;}.elementor-9695 .elementor-element.elementor-element-3d6beb3{text-align:center;}.elementor-9695 .elementor-element.elementor-element-a7c0504{text-align:center;}.elementor-9695 .elementor-element.elementor-element-1e955e6{--padding-top:0px;--padding-bottom:40px;--padding-left:0px;--padding-right:0px;}}@media(min-width:768px){.elementor-9695 .elementor-element.elementor-element-66a0dc8{width:17%;}.elementor-9695 .elementor-element.elementor-element-76fe43c{width:17%;}.elementor-9695 .elementor-element.elementor-element-5f7df81{width:18%;}.elementor-9695 .elementor-element.elementor-element-1d6477f{width:20.649%;}.elementor-9695 .elementor-element.elementor-element-deadc23{width:25%;}.elementor-9695 .elementor-element.elementor-element-bbc72b1{--width:100%;}}@media(max-width:1024px) and (min-width:768px){.elementor-9695 .elementor-element.elementor-element-66a0dc8{width:33%;}.elementor-9695 .elementor-element.elementor-element-76fe43c{width:33%;}.elementor-9695 .elementor-element.elementor-element-5f7df81{width:33%;}.elementor-9695 .elementor-element.elementor-element-1d6477f{width:33%;}.elementor-9695 .elementor-element.elementor-element-deadc23{width:50%;}.elementor-9695 .elementor-element.elementor-element-643c0aa{--width:85%;}.elementor-9695 .elementor-element.elementor-element-e29cc10{--width:85%;}.elementor-9695 .elementor-element.elementor-element-bbc72b1{--width:100%;}}/* Start custom CSS for button, class: .elementor-element-f3a46eb */.button-transition{
    transition: 2s;
}/* End custom CSS */
/* Start custom CSS for button, class: .elementor-element-f3a46eb */.button-transition{
    transition: 2s;
}/* End custom CSS */
.elementor-10004 .elementor-element.elementor-element-3ec1cc8 > .elementor-container > .elementor-column > .elementor-widget-wrap{align-content:flex-start;align-items:flex-start;}.elementor-10004 .elementor-element.elementor-element-3ec1cc8 > .elementor-container{min-height:130px;}.elementor-10004 .elementor-element.elementor-element-665dbf8 .elementor-button{background-color:var( --e-global-color-accent );padding:13px 30px 13px 30px;}.elementor-10004 .elementor-element.elementor-element-665dbf8 > .elementor-widget-container{margin:0px 0px 2px 0px;}.elementor-10004 .elementor-element.elementor-element-2f7bf35 .elementor-button{background-color:var( --e-global-color-accent );padding:13px 30px 13px 30px;}#elementor-popup-modal-10004 .dialog-message{width:640px;height:auto;}#elementor-popup-modal-10004{justify-content:center;align-items:center;}#elementor-popup-modal-10004 .dialog-widget-content{box-shadow:2px 8px 23px 3px rgba(0,0,0,0.2);margin:15% 0% 0% 0%;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}
</style>
<link rel='stylesheet' id='widget-nav-menu-css' href='/wp-content/plugins/elementor-pro/assets/css/widget-nav-menu.min.css?ver=3.25.3' media='all' />
<link rel='stylesheet' id='widget-search-form-css' href='/wp-content/plugins/elementor-pro/assets/css/widget-search-form.min.css?ver=3.25.3' media='all' />
<link rel='stylesheet' id='elementor-icons-shared-0-css' href='/wp-content/plugins/elementor/assets/lib/font-awesome/css/fontawesome.min.css?ver=5.15.3' media='all' />
<link rel='stylesheet' id='elementor-icons-fa-solid-css' href='/wp-content/plugins/elementor/assets/lib/font-awesome/css/solid.min.css?ver=5.15.3' media='all' />
<link rel='stylesheet' id='widget-image-css' href='/wp-content/plugins/elementor/assets/css/widget-image.min.css?ver=3.25.8' media='all' />
<link rel='stylesheet' id='widget-heading-css' href='/wp-content/plugins/elementor/assets/css/widget-heading.min.css?ver=3.25.8' media='all' />
<link rel='stylesheet' id='widget-icon-list-css' href='/wp-content/plugins/elementor/assets/css/widget-icon-list.min.css?ver=3.25.8' media='all' />
<link rel='stylesheet' id='e-animation-float-css' href='/wp-content/plugins/elementor/assets/lib/animations/styles/e-animation-float.min.css?ver=3.25.8' media='all' />
<link rel='stylesheet' id='widget-text-editor-css' href='/wp-content/plugins/elementor/assets/css/widget-text-editor.min.css?ver=3.25.8' media='all' />
<link rel='stylesheet' id='elementor-icons-css' href='/wp-content/plugins/elementor/assets/lib/eicons/css/elementor-icons.min.css?ver=5.32.0' media='all' />
<style id='elementor-icons-inline-css'>

		.elementor-add-new-section .elementor-add-templately-promo-button{
            background-color: #5d4fff;
            background-image: url(/wp-content/plugins/essential-addons-for-elementor-lite/assets/admin/images/templately/logo-icon.svg);
            background-repeat: no-repeat;
            background-position: center center;
            position: relative;
        }
        
		.elementor-add-new-section .elementor-add-templately-promo-button > i{
            height: 12px;
        }
        
        body .elementor-add-new-section .elementor-add-section-area-button {
            margin-left: 0;
        }

		.elementor-add-new-section .elementor-add-templately-promo-button{
            background-color: #5d4fff;
            background-image: url(/wp-content/plugins/essential-addons-for-elementor-lite/assets/admin/images/templately/logo-icon.svg);
            background-repeat: no-repeat;
            background-position: center center;
            position: relative;
        }
        
		.elementor-add-new-section .elementor-add-templately-promo-button > i{
            height: 12px;
        }
        
        body .elementor-add-new-section .elementor-add-section-area-button {
            margin-left: 0;
        }
</style>
<link rel='stylesheet' id='swiper-css' href='/wp-content/plugins/elementor/assets/lib/swiper/v8/css/swiper.min.css?ver=8.4.5' media='all' />
<link rel='stylesheet' id='e-swiper-css' href='/wp-content/plugins/elementor/assets/css/conditionals/e-swiper.min.css?ver=3.25.8' media='all' />
<link rel='stylesheet' id='e-popup-style-css' href='/wp-content/plugins/elementor-pro/assets/css/conditionals/popup.min.css?ver=3.25.3' media='all' />
<link rel='stylesheet' id='font-awesome-5-all-css' href='/wp-content/plugins/elementor/assets/lib/font-awesome/css/all.min.css?ver=3.25.8' media='all' />
<link rel='stylesheet' id='font-awesome-4-shim-css' href='/wp-content/plugins/elementor/assets/lib/font-awesome/css/v4-shims.min.css?ver=3.25.8' media='all' />
<link rel='stylesheet' id='elementor-icons-ekiticons-css' href='/wp-content/plugins/elementskit-lite/modules/elementskit-icon-pack/assets/css/ekiticons.css?ver=3.3.2' media='all' />
<link rel='stylesheet' id='hello-elementor-child-style-css' href='/wp-content/themes/hello-theme-child-master/style.css?ver=2.0.0' media='all' />
<link rel='stylesheet' id='ekit-widget-styles-css' href='/wp-content/plugins/elementskit-lite/widgets/init/assets/css/widget-styles.css?ver=3.3.2' media='all' />
<link rel='stylesheet' id='ekit-responsive-css' href='/wp-content/plugins/elementskit-lite/widgets/init/assets/css/responsive.css?ver=3.3.2' media='all' />
<link rel='stylesheet' id='eael-general-css' href='/wp-content/plugins/essential-addons-for-elementor-lite/assets/front-end/css/view/general.min.css?ver=6.0.10' media='all' />
<link rel='stylesheet' id='ecs-styles-css' href='/wp-content/plugins/ele-custom-skin/assets/css/ecs-style.css?ver=3.1.9' media='all' />
<link rel='stylesheet' id='bdt-uikit-css' href='/wp-content/plugins/bdthemes-element-pack/assets/css/bdt-uikit.css?ver=3.21.7' media='all' />
<link rel='stylesheet' id='ep-helper-css' href='/wp-content/plugins/bdthemes-element-pack/assets/css/ep-helper.css?ver=7.18.7' media='all' />
<style id="google-fonts-1-css" media="all">/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtE6F15M.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWvU6F15M.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtU6F15M.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuk6F15M.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWu06F15M.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWxU6F15M.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqW106F15M.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtk6F15M.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWt06F15M.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuU6F.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtE6F15M.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWvU6F15M.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtU6F15M.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuk6F15M.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWu06F15M.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWxU6F15M.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqW106F15M.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtk6F15M.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWt06F15M.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuU6F.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtE6F15M.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWvU6F15M.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtU6F15M.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuk6F15M.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWu06F15M.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWxU6F15M.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqW106F15M.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtk6F15M.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWt06F15M.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuU6F.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtE6F15M.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWvU6F15M.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtU6F15M.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuk6F15M.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWu06F15M.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWxU6F15M.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqW106F15M.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtk6F15M.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWt06F15M.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuU6F.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtE6F15M.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWvU6F15M.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtU6F15M.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuk6F15M.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWu06F15M.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWxU6F15M.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqW106F15M.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtk6F15M.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWt06F15M.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuU6F.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtE6F15M.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWvU6F15M.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtU6F15M.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuk6F15M.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWu06F15M.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWxU6F15M.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqW106F15M.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWtk6F15M.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWt06F15M.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: italic;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memtYaGs126MiZpBA-UFUIcVXSCEkx2cmqvXlWqWuU6F.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSKmu1aB.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSumu1aB.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSOmu1aB.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSymu1aB.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS2mu1aB.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTVOmu1aB.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTUGmu1aB.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSCmu1aB.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSGmu1aB.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 300;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS-muw.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSKmu1aB.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSumu1aB.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSOmu1aB.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSymu1aB.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS2mu1aB.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTVOmu1aB.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTUGmu1aB.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSCmu1aB.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSGmu1aB.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS-muw.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSKmu1aB.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSumu1aB.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSOmu1aB.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSymu1aB.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS2mu1aB.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTVOmu1aB.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTUGmu1aB.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSCmu1aB.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSGmu1aB.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 500;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS-muw.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSKmu1aB.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSumu1aB.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSOmu1aB.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSymu1aB.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS2mu1aB.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTVOmu1aB.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTUGmu1aB.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSCmu1aB.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSGmu1aB.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS-muw.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSKmu1aB.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSumu1aB.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSOmu1aB.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSymu1aB.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS2mu1aB.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTVOmu1aB.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTUGmu1aB.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSCmu1aB.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSGmu1aB.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS-muw.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSKmu1aB.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSumu1aB.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSOmu1aB.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSymu1aB.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* hebrew */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS2mu1aB.woff2) format('woff2');
  unicode-range: U+0307-0308, U+0590-05FF, U+200C-2010, U+20AA, U+25CC, U+FB1D-FB4F;
}
/* math */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTVOmu1aB.woff2) format('woff2');
  unicode-range: U+0302-0303, U+0305, U+0307-0308, U+0310, U+0312, U+0315, U+031A, U+0326-0327, U+032C, U+032F-0330, U+0332-0333, U+0338, U+033A, U+0346, U+034D, U+0391-03A1, U+03A3-03A9, U+03B1-03C9, U+03D1, U+03D5-03D6, U+03F0-03F1, U+03F4-03F5, U+2016-2017, U+2034-2038, U+203C, U+2040, U+2043, U+2047, U+2050, U+2057, U+205F, U+2070-2071, U+2074-208E, U+2090-209C, U+20D0-20DC, U+20E1, U+20E5-20EF, U+2100-2112, U+2114-2115, U+2117-2121, U+2123-214F, U+2190, U+2192, U+2194-21AE, U+21B0-21E5, U+21F1-21F2, U+21F4-2211, U+2213-2214, U+2216-22FF, U+2308-230B, U+2310, U+2319, U+231C-2321, U+2336-237A, U+237C, U+2395, U+239B-23B7, U+23D0, U+23DC-23E1, U+2474-2475, U+25AF, U+25B3, U+25B7, U+25BD, U+25C1, U+25CA, U+25CC, U+25FB, U+266D-266F, U+27C0-27FF, U+2900-2AFF, U+2B0E-2B11, U+2B30-2B4C, U+2BFE, U+3030, U+FF5B, U+FF5D, U+1D400-1D7FF, U+1EE00-1EEFF;
}
/* symbols */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTUGmu1aB.woff2) format('woff2');
  unicode-range: U+0001-000C, U+000E-001F, U+007F-009F, U+20DD-20E0, U+20E2-20E4, U+2150-218F, U+2190, U+2192, U+2194-2199, U+21AF, U+21E6-21F0, U+21F3, U+2218-2219, U+2299, U+22C4-22C6, U+2300-243F, U+2440-244A, U+2460-24FF, U+25A0-27BF, U+2800-28FF, U+2921-2922, U+2981, U+29BF, U+29EB, U+2B00-2BFF, U+4DC0-4DFF, U+FFF9-FFFB, U+10140-1018E, U+10190-1019C, U+101A0, U+101D0-101FD, U+102E0-102FB, U+10E60-10E7E, U+1D2C0-1D2D3, U+1D2E0-1D37F, U+1F000-1F0FF, U+1F100-1F1AD, U+1F1E6-1F1FF, U+1F30D-1F30F, U+1F315, U+1F31C, U+1F31E, U+1F320-1F32C, U+1F336, U+1F378, U+1F37D, U+1F382, U+1F393-1F39F, U+1F3A7-1F3A8, U+1F3AC-1F3AF, U+1F3C2, U+1F3C4-1F3C6, U+1F3CA-1F3CE, U+1F3D4-1F3E0, U+1F3ED, U+1F3F1-1F3F3, U+1F3F5-1F3F7, U+1F408, U+1F415, U+1F41F, U+1F426, U+1F43F, U+1F441-1F442, U+1F444, U+1F446-1F449, U+1F44C-1F44E, U+1F453, U+1F46A, U+1F47D, U+1F4A3, U+1F4B0, U+1F4B3, U+1F4B9, U+1F4BB, U+1F4BF, U+1F4C8-1F4CB, U+1F4D6, U+1F4DA, U+1F4DF, U+1F4E3-1F4E6, U+1F4EA-1F4ED, U+1F4F7, U+1F4F9-1F4FB, U+1F4FD-1F4FE, U+1F503, U+1F507-1F50B, U+1F50D, U+1F512-1F513, U+1F53E-1F54A, U+1F54F-1F5FA, U+1F610, U+1F650-1F67F, U+1F687, U+1F68D, U+1F691, U+1F694, U+1F698, U+1F6AD, U+1F6B2, U+1F6B9-1F6BA, U+1F6BC, U+1F6C6-1F6CF, U+1F6D3-1F6D7, U+1F6E0-1F6EA, U+1F6F0-1F6F3, U+1F6F7-1F6FC, U+1F700-1F7FF, U+1F800-1F80B, U+1F810-1F847, U+1F850-1F859, U+1F860-1F887, U+1F890-1F8AD, U+1F8B0-1F8BB, U+1F8C0-1F8C1, U+1F900-1F90B, U+1F93B, U+1F946, U+1F984, U+1F996, U+1F9E9, U+1FA00-1FA6F, U+1FA70-1FA7C, U+1FA80-1FA89, U+1FA8F-1FAC6, U+1FACE-1FADC, U+1FADF-1FAE9, U+1FAF0-1FAF8, U+1FB00-1FBFF;
}
/* vietnamese */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSCmu1aB.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTSGmu1aB.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 800;
  font-stretch: 100%;
  src: url(/fonts.gstatic.com/s/opensans/v40/memvYaGs126MiZpBA-UvWbX2vVnXBbObj2OVTS-muw.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOiCnqEu92Fr1Mu51QrEz0dL_nz.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOiCnqEu92Fr1Mu51QrEzQdL_nz.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOiCnqEu92Fr1Mu51QrEzwdL_nz.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOiCnqEu92Fr1Mu51QrEzMdL_nz.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOiCnqEu92Fr1Mu51QrEz8dL_nz.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOiCnqEu92Fr1Mu51QrEz4dL_nz.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOiCnqEu92Fr1Mu51QrEzAdLw.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TjASc3CsTKlA.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TjASc-CsTKlA.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TjASc2CsTKlA.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TjASc5CsTKlA.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TjASc1CsTKlA.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TjASc0CsTKlA.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TjASc6CsQ.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1Mu51xFIzIFKw.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1Mu51xMIzIFKw.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1Mu51xEIzIFKw.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1Mu51xLIzIFKw.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1Mu51xHIzIFKw.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1Mu51xGIzIFKw.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1Mu51xIIzI.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51S7ACc3CsTKlA.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51S7ACc-CsTKlA.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51S7ACc2CsTKlA.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51S7ACc5CsTKlA.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51S7ACc1CsTKlA.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51S7ACc0CsTKlA.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51S7ACc6CsQ.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TzBic3CsTKlA.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TzBic-CsTKlA.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TzBic2CsTKlA.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TzBic5CsTKlA.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TzBic1CsTKlA.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TzBic0CsTKlA.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TzBic6CsQ.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TLBCc3CsTKlA.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TLBCc-CsTKlA.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TLBCc2CsTKlA.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TLBCc5CsTKlA.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TLBCc1CsTKlA.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TLBCc0CsTKlA.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: italic;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOjCnqEu92Fr1Mu51TLBCc6CsQ.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1MmgVxFIzIFKw.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1MmgVxMIzIFKw.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1MmgVxEIzIFKw.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1MmgVxLIzIFKw.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1MmgVxHIzIFKw.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1MmgVxGIzIFKw.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 100;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOkCnqEu92Fr1MmgVxIIzI.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmSU5fCRc4EsA.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmSU5fABc4EsA.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmSU5fCBc4EsA.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmSU5fBxc4EsA.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmSU5fCxc4EsA.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmSU5fChc4EsA.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 300;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmSU5fBBc4.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOmCnqEu92Fr1Mu72xKOzY.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOmCnqEu92Fr1Mu5mxKOzY.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOmCnqEu92Fr1Mu7mxKOzY.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOmCnqEu92Fr1Mu4WxKOzY.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOmCnqEu92Fr1Mu7WxKOzY.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOmCnqEu92Fr1Mu7GxKOzY.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 400;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOmCnqEu92Fr1Mu4mxK.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmEU9fCRc4EsA.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmEU9fABc4EsA.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmEU9fCBc4EsA.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmEU9fBxc4EsA.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmEU9fCxc4EsA.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmEU9fChc4EsA.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 500;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmEU9fBBc4.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmWUlfCRc4EsA.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmWUlfABc4EsA.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmWUlfCBc4EsA.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmWUlfBxc4EsA.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmWUlfCxc4EsA.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmWUlfChc4EsA.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 700;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmWUlfBBc4.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
/* cyrillic-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmYUtfCRc4EsA.woff2) format('woff2');
  unicode-range: U+0460-052F, U+1C80-1C8A, U+20B4, U+2DE0-2DFF, U+A640-A69F, U+FE2E-FE2F;
}
/* cyrillic */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmYUtfABc4EsA.woff2) format('woff2');
  unicode-range: U+0301, U+0400-045F, U+0490-0491, U+04B0-04B1, U+2116;
}
/* greek-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmYUtfCBc4EsA.woff2) format('woff2');
  unicode-range: U+1F00-1FFF;
}
/* greek */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmYUtfBxc4EsA.woff2) format('woff2');
  unicode-range: U+0370-0377, U+037A-037F, U+0384-038A, U+038C, U+038E-03A1, U+03A3-03FF;
}
/* vietnamese */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmYUtfCxc4EsA.woff2) format('woff2');
  unicode-range: U+0102-0103, U+0110-0111, U+0128-0129, U+0168-0169, U+01A0-01A1, U+01AF-01B0, U+0300-0301, U+0303-0304, U+0308-0309, U+0323, U+0329, U+1EA0-1EF9, U+20AB;
}
/* latin-ext */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmYUtfChc4EsA.woff2) format('woff2');
  unicode-range: U+0100-02BA, U+02BD-02C5, U+02C7-02CC, U+02CE-02D7, U+02DD-02FF, U+0304, U+0308, U+0329, U+1D00-1DBF, U+1E00-1E9F, U+1EF2-1EFF, U+2020, U+20A0-20AB, U+20AD-20C0, U+2113, U+2C60-2C7F, U+A720-A7FF;
}
/* latin */
@font-face {
  font-family: 'Roboto';
  font-style: normal;
  font-weight: 900;
  src: url(/fonts.gstatic.com/s/roboto/v32/KFOlCnqEu92Fr1MmYUtfBBc4.woff2) format('woff2');
  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+0304, U+0308, U+0329, U+2000-206F, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
}
</style>
<link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin><script id="webtoffee-cookie-consent-js-extra" type="4364f5cca7525295a0b533ca-text/javascript">
var _wccConfig = {"_ipData":[],"_assetsURL":"\/wp-content\/plugins\/webtoffee-cookie-consent\/lite\/frontend\/images\/","_publicURL":"https:\/\/www.fidelitybank.ng","_categories":[{"name":"Necessary","slug":"necessary","isNecessary":true,"ccpaDoNotSell":true,"cookies":[{"cookieID":"elementor","domain":"fidelitybank.ng","provider":""},{"cookieID":"__cf_bm","domain":".fidelitybank.ng","provider":"cloudflare.com"},{"cookieID":"wt_consent","domain":".fidelitybank.ng","provider":""}],"active":true,"defaultConsent":{"gdpr":true,"ccpa":true}},{"name":"Functional","slug":"functional","isNecessary":false,"ccpaDoNotSell":true,"cookies":[{"cookieID":"ytidb::LAST_RESULT_ENTRY_KEY","domain":"youtube.com","provider":"youtube.com"},{"cookieID":"yt-remote-device-id","domain":"youtube.com","provider":"youtube.com"},{"cookieID":"yt-remote-connected-devices","domain":"youtube.com","provider":"youtube.com"},{"cookieID":"yt-remote-session-app","domain":"youtube.com","provider":"youtube.com"},{"cookieID":"yt-remote-session-name","domain":"youtube.com","provider":"youtube.com"},{"cookieID":"yt-remote-fast-check-period","domain":"youtube.com","provider":"youtube.com"},{"cookieID":"_dc_gtm_UA-*","domain":".fidelitybank.ng","provider":"google-analytics.com|googletagmanager.com\/gtag\/js"}],"active":true,"defaultConsent":{"gdpr":false,"ccpa":false}},{"name":"Analytics","slug":"analytics","isNecessary":false,"ccpaDoNotSell":true,"cookies":[{"cookieID":"Google Analytics","domain":"www.fidelitybank.ng","provider":""},{"cookieID":"YouTube","domain":"youtube.com","provider":""},{"cookieID":"Netcore","domain":"netcoresmartech.com","provider":""},{"cookieID":"_ga_*","domain":".fidelitybank.ng","provider":"google-analytics.com|googletagmanager.com\/gtag\/js"},{"cookieID":"_ga","domain":".fidelitybank.ng","provider":"google-analytics.com|googletagmanager.com\/gtag\/js"},{"cookieID":"_gcl_au","domain":".fidelitybank.ng","provider":"googletagmanager.com"},{"cookieID":"_gid","domain":".fidelitybank.ng","provider":"google-analytics.com|googletagmanager.com\/gtag\/js"}],"active":true,"defaultConsent":{"gdpr":false,"ccpa":false}},{"name":"Performance","slug":"performance","isNecessary":false,"ccpaDoNotSell":true,"cookies":[],"active":true,"defaultConsent":{"gdpr":false,"ccpa":false}},{"name":"Advertisement","slug":"advertisement","isNecessary":false,"ccpaDoNotSell":true,"cookies":[{"cookieID":"YSC","domain":".youtube.com","provider":"youtube.com"},{"cookieID":"VISITOR_INFO1_LIVE","domain":".youtube.com","provider":"youtube.com"},{"cookieID":"VISITOR_PRIVACY_METADATA","domain":".youtube.com","provider":"youtube.com"},{"cookieID":"yt.innertube::nextId","domain":"youtube.com","provider":"youtube.com"},{"cookieID":"yt.innertube::requests","domain":"youtube.com","provider":"youtube.com"},{"cookieID":"ck","domain":"fidelitybank.ng","provider":"addthis.com"},{"cookieID":"test_cookie","domain":".doubleclick.net","provider":"doubleclick.net"}],"active":true,"defaultConsent":{"gdpr":false,"ccpa":false}},{"name":"Others","slug":"others","isNecessary":false,"ccpaDoNotSell":true,"cookies":[{"cookieID":"_gat_G-Q351SFPM7R","domain":".fidelitybank.ng","provider":""},{"cookieID":"__sts","domain":"www.fidelitybank.ng","provider":""},{"cookieID":"__stp","domain":"www.fidelitybank.ng","provider":""},{"cookieID":"__stdf","domain":"www.fidelitybank.ng","provider":""},{"cookieID":"__stgeo","domain":"www.fidelitybank.ng","provider":""},{"cookieID":"__stbpnenable","domain":"www.fidelitybank.ng","provider":""},{"cookieID":"__stat","domain":"www.fidelitybank.ng","provider":""}],"active":true,"defaultConsent":{"gdpr":false,"ccpa":false}}],"_activeLaw":"gdpr","_rootDomain":"","_block":"1","_showBanner":"1","_bannerConfig":{"GDPR":{"settings":{"type":"popup","position":"center","applicableLaw":"gdpr","preferenceCenter":"center","selectedRegion":"ALL","consentExpiry":365,"shortcodes":[{"key":"wcc_readmore","content":"<a href=\"#\" class=\"wcc-policy\" aria-label=\"Cookie Policy\" target=\"_blank\" rel=\"noopener\" data-tag=\"readmore-button\">Cookie Policy<\/a>","tag":"readmore-button","status":false,"attributes":{"rel":"nofollow","target":"_blank"}},{"key":"wcc_show_desc","content":"<button class=\"wcc-show-desc-btn\" data-tag=\"show-desc-button\" aria-label=\"Show more\">Show more<\/button>","tag":"show-desc-button","status":true,"attributes":[]},{"key":"wcc_hide_desc","content":"<button class=\"wcc-show-desc-btn\" data-tag=\"hide-desc-button\" aria-label=\"Show less\">Show less<\/button>","tag":"hide-desc-button","status":true,"attributes":[]},{"key":"wcc_category_toggle_label","content":"[wcc_{{status}}_category_label] [wcc_preference_{{category_slug}}_title]","tag":"","status":true,"attributes":[]},{"key":"wcc_enable_category_label","content":"Enable","tag":"","status":true,"attributes":[]},{"key":"wcc_disable_category_label","content":"Disable","tag":"","status":true,"attributes":[]},{"key":"wcc_video_placeholder","content":"<div class=\"video-placeholder-normal\" data-tag=\"video-placeholder\" id=\"[UNIQUEID]\"><p class=\"video-placeholder-text-normal\" data-tag=\"placeholder-title\">Please accept cookies to access this content<\/p><\/div>","tag":"","status":true,"attributes":[]},{"key":"wcc_enable_optout_label","content":"Enable","tag":"","status":true,"attributes":[]},{"key":"wcc_disable_optout_label","content":"Disable","tag":"","status":true,"attributes":[]},{"key":"wcc_optout_toggle_label","content":"[wcc_{{status}}_optout_label] [wcc_optout_option_title]","tag":"","status":true,"attributes":[]},{"key":"wcc_optout_option_title","content":"Do Not Sell or Share My Personal Information","tag":"","status":true,"attributes":[]},{"key":"wcc_optout_close_label","content":"Close","tag":"","status":true,"attributes":[]}],"bannerEnabled":true},"behaviours":{"reloadBannerOnAccept":false,"loadAnalyticsByDefault":false,"animations":{"onLoad":"animate","onHide":"sticky"}},"config":{"revisitConsent":{"status":true,"tag":"revisit-consent","position":"bottom-left","meta":{"url":"#"},"styles":[],"elements":{"title":{"type":"text","tag":"revisit-consent-title","status":true,"styles":{"color":"#0056a7"}}}},"preferenceCenter":{"toggle":{"status":true,"tag":"detail-category-toggle","type":"toggle","states":{"active":{"styles":{"background-color":"#000000"}},"inactive":{"styles":{"background-color":"#D0D5D2"}}}},"poweredBy":false},"categoryPreview":{"status":false,"toggle":{"status":true,"tag":"detail-category-preview-toggle","type":"toggle","states":{"active":{"styles":{"background-color":"#000000"}},"inactive":{"styles":{"background-color":"#D0D5D2"}}}}},"videoPlaceholder":{"status":true,"styles":{"background-color":"#002082","border-color":"#002082","color":"#ffffff"}},"readMore":{"status":false,"tag":"readmore-button","type":"link","meta":{"noFollow":true,"newTab":true},"styles":{"color":"#000000","background-color":"transparent","border-color":"transparent"}},"auditTable":{"status":true},"optOption":{"status":true,"toggle":{"status":true,"tag":"optout-option-toggle","type":"toggle","states":{"active":{"styles":{"background-color":"#000000"}},"inactive":{"styles":{"background-color":"#FFFFFF"}}}}}}}},"_version":"3.1.0","_logConsent":"1","_tags":[{"tag":"accept-button","styles":{"color":"#FFFFFF","background-color":"#002082","border-color":"#002082"}},{"tag":"reject-button","styles":{"color":"#002082","background-color":"transparent","border-color":"#002082"}},{"tag":"settings-button","styles":{"color":"#002082","background-color":"transparent","border-color":"#002082"}},{"tag":"readmore-button","styles":{"color":"#000000","background-color":"transparent","border-color":"transparent"}},{"tag":"donotsell-button","styles":{"color":"#1863dc","background-color":"transparent","border-color":"transparent"}},{"tag":"accept-button","styles":{"color":"#FFFFFF","background-color":"#002082","border-color":"#002082"}},{"tag":"revisit-consent","styles":[]}],"_rtl":"","_lawSelected":["GDPR"],"_restApiUrl":"https:\/\/directory.cookieyes.com\/api\/v1\/ip","_renewConsent":"","_restrictToCA":"","_providersToBlock":[{"re":"youtube.com","categories":["functional","advertisement"]},{"re":"google-analytics.com|googletagmanager.com\/gtag\/js","categories":["functional","analytics"]},{"re":"googletagmanager.com","categories":["analytics"]},{"re":"addthis.com","categories":["advertisement"]},{"re":"doubleclick.net","categories":["advertisement"]}]};
var _wccStyles = {"css":{"GDPR":".wcc-overlay{background: #000000; opacity: 0.4; position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 9999999;}.wcc-popup-overflow{overflow: hidden;}.wcc-hide{display: none;}.wcc-btn-revisit-wrapper{display: flex; padding: 6px; border-radius: 8px; opacity: 0px; background-color:#ffffff; box-shadow: 0px 3px 10px 0px #798da04d;  align-items: center; justify-content: center;  position: fixed; z-index: 999999; cursor: pointer;}.wcc-revisit-bottom-left{bottom: 15px; left: 15px;}.wcc-revisit-bottom-right{bottom: 15px; right: 15px;}.wcc-btn-revisit-wrapper .wcc-btn-revisit{display: flex; align-items: center; justify-content: center; background: none; border: none; cursor: pointer; position: relative; margin: 0; padding: 0;}.wcc-btn-revisit-wrapper .wcc-btn-revisit img{max-width: fit-content; margin: 0; } .wcc-btn-revisit-wrapper .wcc-revisit-help-text{font-size:14px; margin-left:4px; display:none;}.wcc-btn-revisit-wrapper:hover .wcc-revisit-help-text {display: block;}.wcc-revisit-hide{display: none;}.wcc-preference-btn:hover{cursor:pointer; text-decoration:underline;}.wcc-cookie-audit-table { font-family: inherit; border-collapse: collapse; width: 100%;} .wcc-cookie-audit-table th, .wcc-cookie-audit-table td {text-align: left; padding: 10px; font-size: 12px; color: #000000; word-break: normal; background-color: #d9dfe7; border: 1px solid #cbced6;} .wcc-cookie-audit-table tr:nth-child(2n + 1) td { background: #f1f5fa; }.wcc-consent-container{position: fixed; width: 440px; box-sizing: border-box; z-index: 99999999; transform: translate(-50%, -50%); border-radius: 6px;}.wcc-consent-container .wcc-consent-bar{background: #ffffff; border: 1px solid; padding: 20px 26px; border-radius: 6px; box-shadow: 0 -1px 10px 0 #acabab4d;}.wcc-consent-bar .wcc-banner-btn-close{position: absolute; right: 10px; top: 8px; background: none; border: none; cursor: pointer; padding: 0; margin: 0; height: auto; width: auto; min-height: 0; line-height: 0; text-shadow: none; box-shadow: none;}.wcc-consent-bar .wcc-banner-btn-close img{height: 10px; width: 10px; margin: 0;}.wcc-popup-center{top: 50%; left: 50%;}.wcc-custom-brand-logo-wrapper .wcc-custom-brand-logo{width: 100px; height: auto; margin: 0 0 12px 0;}.wcc-notice .wcc-title{color: #212121; font-weight: 700; font-size: 18px; line-height: 24px; margin: 0 0 12px 0; word-break: break-word;}.wcc-notice-des *{font-size: 14px;}.wcc-notice-des{color: #212121; font-size: 14px; line-height: 24px; font-weight: 400;}.wcc-notice-des img{min-height: 25px; min-width: 25px;}.wcc-consent-bar .wcc-notice-des p{color: inherit; margin-top: 0; word-break: break-word;}.wcc-notice-des p:last-child{margin-bottom: 0;}.wcc-notice-des a.wcc-policy,.wcc-notice-des button.wcc-policy{font-size: 14px; color: #1863dc; white-space: nowrap; cursor: pointer; background: transparent; border: 1px solid; text-decoration: underline;}.wcc-notice-des button.wcc-policy{padding: 0;}.wcc-notice-des a.wcc-policy:focus-visible,.wcc-consent-bar .wcc-banner-btn-close:focus-visible,.wcc-notice-des button.wcc-policy:focus-visible,.wcc-preference-content-wrapper .wcc-show-desc-btn:focus-visible,.wcc-accordion-header .wcc-accordion-btn:focus-visible,.wcc-preference-header .wcc-btn-close:focus-visible,.wcc-switch input[type=\"checkbox\"]:focus-visible,.wcc-btn:focus-visible{outline: 2px solid #1863dc; outline-offset: 2px;}.wcc-btn:focus:not(:focus-visible),.wcc-accordion-header .wcc-accordion-btn:focus:not(:focus-visible),.wcc-preference-content-wrapper .wcc-show-desc-btn:focus:not(:focus-visible),.wcc-btn-revisit-wrapper .wcc-btn-revisit:focus:not(:focus-visible),.wcc-preference-header .wcc-btn-close:focus:not(:focus-visible),.wcc-consent-bar .wcc-banner-btn-close:focus:not(:focus-visible){outline: 0;}button.wcc-show-desc-btn:not(:hover):not(:active){color: #1863dc; background: transparent;}button.wcc-accordion-btn:not(:hover):not(:active),button.wcc-banner-btn-close:not(:hover):not(:active),button.wcc-btn-close:not(:hover):not(:active),button.wcc-btn-revisit:not(:hover):not(:active){background: transparent;}.wcc-consent-bar button:hover,.wcc-modal.wcc-modal-open button:hover,.wcc-consent-bar button:focus,.wcc-modal.wcc-modal-open button:focus{text-decoration: none;}.wcc-notice-btn-wrapper{display: flex; justify-content: center; align-items: center; flex-wrap: wrap; gap: 8px; margin-top: 16px;}.wcc-notice-btn-wrapper .wcc-btn{text-shadow: none; box-shadow: none;}.wcc-btn{flex: auto; max-width: 100%; font-size: 14px; font-family: inherit; line-height: 24px; padding: 8px; font-weight: 500; border-radius: 2px; cursor: pointer; text-align: center; text-transform: none; min-height: 0;}.wcc-btn:hover{opacity: 0.8;}.wcc-btn-customize{color: #1863dc; background: transparent; border: 2px solid #1863dc;}.wcc-btn-reject{color: #1863dc; background: transparent; border: 2px solid #1863dc;}.wcc-btn-accept{background: #1863dc; color: #ffffff; border: 2px solid #1863dc;}.wcc-btn:last-child{margin-right: 0;}@media (max-width: 576px){.wcc-box-bottom-left{bottom: 0; left: 0;}.wcc-box-bottom-right{bottom: 0; right: 0;}.wcc-box-top-left{top: 0; left: 0;}.wcc-box-top-right{top: 0; right: 0;}}@media (max-width: 440px){.wcc-popup-center{width: 100%; max-width: 100%;}.wcc-consent-container .wcc-consent-bar{padding: 20px 0;}.wcc-custom-brand-logo-wrapper, .wcc-notice .wcc-title, .wcc-notice-des, .wcc-notice-btn-wrapper{padding: 0 24px;}.wcc-notice-des{max-height: 40vh; overflow-y: scroll;}.wcc-notice-btn-wrapper{flex-direction: column; gap: 10px;}.wcc-btn{width: 100%;}.wcc-notice-btn-wrapper .wcc-btn-customize{order: 2;}.wcc-notice-btn-wrapper .wcc-btn-reject{order: 3;}.wcc-notice-btn-wrapper .wcc-btn-accept{order: 1;}}@media (max-width: 352px){.wcc-notice .wcc-title{font-size: 16px;}.wcc-notice-des *{font-size: 12px;}.wcc-notice-des, .wcc-btn, .wcc-notice-des a.wcc-policy{font-size: 12px;}}.wcc-modal.wcc-modal-open{display: flex; visibility: visible; -webkit-transform: translate(-50%, -50%); -moz-transform: translate(-50%, -50%); -ms-transform: translate(-50%, -50%); -o-transform: translate(-50%, -50%); transform: translate(-50%, -50%); top: 50%; left: 50%; transition: all 1s ease;}.wcc-modal{box-shadow: 0 32px 68px rgba(0, 0, 0, 0.3); margin: 0 auto; position: fixed; max-width: 100%; background: #ffffff; top: 50%; box-sizing: border-box; border-radius: 6px; z-index: 999999999; color: #212121; -webkit-transform: translate(-50%, 100%); -moz-transform: translate(-50%, 100%); -ms-transform: translate(-50%, 100%); -o-transform: translate(-50%, 100%); transform: translate(-50%, 100%); visibility: hidden; transition: all 0s ease;}.wcc-preference-center{max-height: 79vh; overflow: hidden; width: 845px; overflow: hidden; flex: 1 1 0; display: flex; flex-direction: column; border-radius: 6px;}.wcc-preference-header{display: flex; align-items: center; justify-content: space-between; padding: 22px 24px; border-bottom: 1px solid;}.wcc-preference-header .wcc-preference-title{font-size: 18px; font-weight: 700; line-height: 24px; word-break: break-word;}.wcc-preference-header .wcc-btn-close{cursor: pointer; vertical-align: middle; padding: 0; margin: 0; background: none; border: none; height: auto; width: auto; min-height: 0; line-height: 0; box-shadow: none; text-shadow: none;}.wcc-preference-header .wcc-btn-close img{margin: 0; height: 10px; width: 10px;}.wcc-preference-body-wrapper{padding: 0 24px; flex: 1; overflow: auto; box-sizing: border-box;}.wcc-preference-content-wrapper *{font-size: 14px;}.wcc-preference-content-wrapper{font-size: 14px; line-height: 24px; font-weight: 400; padding: 12px 0; border-bottom: 1px solid;}.wcc-preference-content-wrapper img{min-height: 25px; min-width: 25px;}.wcc-preference-content-wrapper .wcc-show-desc-btn{font-size: 14px; font-family: inherit; color: #1863dc; text-decoration: none; line-height: 24px; padding: 0; margin: 0; white-space: nowrap; cursor: pointer; background: transparent; border-color: transparent; text-transform: none; min-height: 0; text-shadow: none; box-shadow: none;}.wcc-preference-body-wrapper .wcc-preference-content-wrapper p{color: inherit; margin-top: 0;}.wcc-preference-content-wrapper p:last-child{margin-bottom: 0;}.wcc-accordion-wrapper{margin-bottom: 10px;}.wcc-accordion{border-bottom: 1px solid;}.wcc-accordion:last-child{border-bottom: none;}.wcc-accordion .wcc-accordion-item{display: flex; margin-top: 10px;}.wcc-accordion .wcc-accordion-body{display: none;}.wcc-accordion.wcc-accordion-active .wcc-accordion-body{display: block; padding: 0 22px; margin-bottom: 16px;}.wcc-accordion-header-wrapper{width: 100%; cursor: pointer;}.wcc-accordion-item .wcc-accordion-header{display: flex; justify-content: space-between; align-items: center;}.wcc-accordion-header .wcc-accordion-btn{font-size: 16px; font-family: inherit; color: #212121; line-height: 24px; background: none; border: none; font-weight: 700; padding: 0; margin: 0; cursor: pointer; text-transform: none; min-height: 0; text-shadow: none; box-shadow: none;}.wcc-accordion-header .wcc-always-active{color: #008000; font-weight: 600; line-height: 24px; font-size: 14px;}.wcc-accordion-header-des *{font-size: 14px;}.wcc-accordion-header-des{font-size: 14px; line-height: 24px; margin: 10px 0 16px 0;}.wcc-accordion-header-wrapper .wcc-accordion-header-des p{color: inherit; margin-top: 0;}.wcc-accordion-chevron{margin-right: 22px; position: relative; cursor: pointer;}.wcc-accordion-chevron-hide{display: none;}.wcc-accordion .wcc-accordion-chevron i::before{content: \"\"; position: absolute; border-right: 1.4px solid; border-bottom: 1.4px solid; border-color: inherit; height: 6px; width: 6px; -webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg); transition: all 0.2s ease-in-out; top: 8px;}.wcc-accordion.wcc-accordion-active .wcc-accordion-chevron i::before{-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg);}.wcc-audit-table{background: #f4f4f4; border-radius: 6px;}.wcc-audit-table .wcc-empty-cookies-text{color: inherit; font-size: 12px; line-height: 24px; margin: 0; padding: 10px;}.wcc-audit-table .wcc-cookie-des-table{font-size: 12px; line-height: 24px; font-weight: normal; padding: 15px 10px; border-bottom: 1px solid; border-bottom-color: inherit; margin: 0;}.wcc-audit-table .wcc-cookie-des-table:last-child{border-bottom: none;}.wcc-audit-table .wcc-cookie-des-table li{list-style-type: none; display: flex; padding: 3px 0;}.wcc-audit-table .wcc-cookie-des-table li:first-child{padding-top: 0;}.wcc-cookie-des-table li div:first-child{width: 100px; font-weight: 600; word-break: break-word; word-wrap: break-word;}.wcc-cookie-des-table li div:last-child{flex: 1; word-break: break-word; word-wrap: break-word; margin-left: 8px;}.wcc-cookie-des-table li div:last-child p{color: inherit; margin-top: 0;}.wcc-cookie-des-table li div:last-child p:last-child{margin-bottom: 0;}.wcc-footer-shadow{display: block; width: 100%; height: 40px; background: linear-gradient(180deg, rgba(255, 255, 255, 0) 0%, #ffffff 100%); position: absolute; bottom: calc(100% - 1px);}.wcc-footer-wrapper{position: relative;}.wcc-prefrence-btn-wrapper{display: flex; flex-wrap: wrap; gap: 8px; align-items: center; justify-content: center; padding: 22px 24px; border-top: 1px solid;}.wcc-prefrence-btn-wrapper .wcc-btn{text-shadow: none; box-shadow: none;}.wcc-btn-preferences{color: #1863dc; background: transparent; border: 2px solid #1863dc;}.wcc-preference-header,.wcc-preference-body-wrapper,.wcc-preference-content-wrapper,.wcc-accordion-wrapper,.wcc-accordion,.wcc-accordion-wrapper,.wcc-footer-wrapper,.wcc-prefrence-btn-wrapper{border-color: inherit;}@media (max-width: 845px){.wcc-modal{max-width: calc(100% - 16px);}}@media (max-width: 576px){.wcc-modal{max-width: 100%;}.wcc-preference-center{max-height: 100vh;}.wcc-prefrence-btn-wrapper{flex-direction: column; gap: 10px;}.wcc-accordion.wcc-accordion-active .wcc-accordion-body{padding-right: 0;}.wcc-prefrence-btn-wrapper .wcc-btn{width: 100%;}.wcc-prefrence-btn-wrapper .wcc-btn-reject{order: 3;}.wcc-prefrence-btn-wrapper .wcc-btn-accept{order: 1;}.wcc-prefrence-btn-wrapper .wcc-btn-preferences{order: 2;}}@media (max-width: 425px){.wcc-accordion-chevron{margin-right: 15px;}.wcc-accordion.wcc-accordion-active .wcc-accordion-body{padding: 0 15px;}}@media (max-width: 352px){.wcc-preference-header .wcc-preference-title{font-size: 16px;}.wcc-preference-header{padding: 16px 24px;}.wcc-preference-content-wrapper *, .wcc-accordion-header-des *{font-size: 12px;}.wcc-preference-content-wrapper, .wcc-preference-content-wrapper .wcc-show-more, .wcc-accordion-header .wcc-always-active, .wcc-accordion-header-des, .wcc-preference-content-wrapper .wcc-show-desc-btn{font-size: 12px;}.wcc-accordion-header .wcc-accordion-btn{font-size: 14px;}}.wcc-switch{display: flex;}.wcc-switch input[type=\"checkbox\"]{position: relative; width: 44px; height: 24px; margin: 0; background: #d0d5d2; -webkit-appearance: none; border-radius: 50px; cursor: pointer; outline: 0; border: none; top: 0;}.wcc-switch input[type=\"checkbox\"]:checked{background: #1863dc;}.wcc-switch input[type=\"checkbox\"]:before{position: absolute; content: \"\"; height: 20px; width: 20px; left: 2px; bottom: 2px; border-radius: 50%; background-color: white; -webkit-transition: 0.4s; transition: 0.4s; margin: 0;}.wcc-switch input[type=\"checkbox\"]:after{display: none;}.wcc-switch input[type=\"checkbox\"]:checked:before{-webkit-transform: translateX(20px); -ms-transform: translateX(20px); transform: translateX(20px);}@media (max-width: 425px){.wcc-switch input[type=\"checkbox\"]{width: 38px; height: 21px;}.wcc-switch input[type=\"checkbox\"]:before{height: 17px; width: 17px;}.wcc-switch input[type=\"checkbox\"]:checked:before{-webkit-transform: translateX(17px); -ms-transform: translateX(17px); transform: translateX(17px);}}.video-placeholder-youtube{background-size: 100% 100%; background-position: center; background-repeat: no-repeat; background-color: #b2b0b059; position: relative; display: flex; align-items: center; justify-content: center; max-width: 100%;}.video-placeholder-text-youtube{text-align: center; align-items: center; padding: 10px 16px; background-color: #000000cc; color: #ffffff; border: 1px solid; border-radius: 2px; cursor: pointer;}.video-placeholder-normal{background-image: url(\"\/wp-content\/plugins\/webtoffee-cookie-consent\/lite\/frontend\/images\/placeholder.svg\"); background-size: 80px; background-position: center; background-repeat: no-repeat; background-color: #b2b0b059; position: relative; display: flex; align-items: flex-end; justify-content: center; max-width: 100%;}.video-placeholder-text-normal{align-items: center; padding: 10px 16px; text-align: center; border: 1px solid; border-radius: 2px; cursor: pointer;}.wcc-rtl{direction: rtl; text-align: right;}.wcc-rtl .wcc-banner-btn-close{left: 9px; right: auto;}.wcc-rtl .wcc-notice-btn-wrapper .wcc-btn:last-child{margin-right: 8px;}.wcc-rtl .wcc-notice-btn-wrapper .wcc-btn:first-child{margin-right: 0;}.wcc-rtl .wcc-notice-btn-wrapper{margin-left: 0;}.wcc-rtl .wcc-prefrence-btn-wrapper .wcc-btn{margin-right: 8px;}.wcc-rtl .wcc-prefrence-btn-wrapper .wcc-btn:first-child{margin-right: 0;}.wcc-rtl .wcc-accordion .wcc-accordion-chevron i::before{border: none; border-left: 1.4px solid; border-top: 1.4px solid; left: 12px;}.wcc-rtl .wcc-accordion.wcc-accordion-active .wcc-accordion-chevron i::before{-webkit-transform: rotate(-135deg); -moz-transform: rotate(-135deg); -ms-transform: rotate(-135deg); -o-transform: rotate(-135deg); transform: rotate(-135deg);}@media (max-width: 768px){.wcc-rtl .wcc-notice-btn-wrapper{margin-right: 0;}}@media (max-width: 576px){.wcc-rtl .wcc-notice-btn-wrapper .wcc-btn:last-child{margin-right: 0;}.wcc-rtl .wcc-prefrence-btn-wrapper .wcc-btn{margin-right: 0;}.wcc-rtl .wcc-accordion.wcc-accordion-active .wcc-accordion-body{padding: 0 22px 0 0;}}@media (max-width: 425px){.wcc-rtl .wcc-accordion.wcc-accordion-active .wcc-accordion-body{padding: 0 15px 0 0;}}@supports not (gap: 10px){.wcc-btn{margin: 0 8px 0 0;}@media (max-width: 440px){.wcc-notice-btn-wrapper{margin-top: 0;}.wcc-btn{margin: 10px 0 0 0;}.wcc-notice-btn-wrapper .wcc-btn-accept{margin-top: 16px;}}@media (max-width: 576px){.wcc-prefrence-btn-wrapper .wcc-btn{margin: 10px 0 0 0;}.wcc-prefrence-btn-wrapper .wcc-btn-accept{margin-top: 0;}}}.wcc-hide-ad-settings{display: none;}button.wcc-iab-dec-btn,.wcc-child-accordion-header-wrapper .wcc-child-accordion-btn,.wcc-vendor-wrapper .wcc-show-table-btn{font-size: 14px; font-family: inherit; line-height: 24px; padding: 0; margin: 0; cursor: pointer; text-decoration: none; background: none; border: none; text-transform: none; min-height: 0; text-shadow: none; box-shadow: none;}button.wcc-iab-dec-btn{color: #1863dc;}.wcc-iab-detail-wrapper{display: flex; flex-direction: column; overflow: hidden; border-color: inherit; height: 100vh;}.wcc-iab-detail-wrapper .wcc-iab-preference-des{padding: 12px 24px; font-size: 14px; line-height: 24px;}.wcc-iab-detail-wrapper .wcc-iab-preference-des p{color: inherit; margin-top: 0;}.wcc-iab-detail-wrapper .wcc-iab-preference-des p:last-child{margin-bottom: 0;}.wcc-iab-detail-wrapper .wcc-iab-navbar-wrapper{padding: 0 24px; border-color: inherit;}.wcc-iab-navbar-wrapper .wcc-iab-navbar{display: flex; list-style-type: none; margin: 0; padding: 0; border-bottom: 1px solid; border-color: inherit;}.wcc-iab-navbar .wcc-iab-nav-item{margin: 0 12px;}.wcc-iab-nav-item.wcc-iab-nav-item-active{border-bottom: 4px solid #1863dc;}.wcc-iab-navbar .wcc-iab-nav-item:first-child{margin: 0 12px 0 0;}.wcc-iab-navbar .wcc-iab-nav-item:last-child{margin: 0 0 0 12px;}.wcc-iab-nav-item button.wcc-iab-nav-btn{padding: 6px 0 14px; color: #757575; font-size: 16px; line-height: 24px; cursor: pointer; background: transparent; border-color: transparent; text-transform: none; min-height: 0; text-shadow: none; box-shadow: none;}.wcc-iab-nav-item.wcc-iab-nav-item-active button.wcc-iab-nav-btn{color: #1863dc; font-weight: 700;}.wcc-iab-detail-wrapper .wcc-iab-detail-sub-wrapper{flex: 1; overflow: auto; border-color: inherit;}.wcc-accordion .wcc-accordion-iab-item{display: flex; padding: 20px 0; cursor: pointer;}.wcc-accordion-header-wrapper .wcc-accordion-header{display: flex; align-items: center; justify-content: space-between;}.wcc-accordion-title {display:flex; align-items:center; font-size:16px;}.wcc-accordion-body .wcc-child-accordion{padding: 0 15px; background-color: #f4f4f4; box-shadow: inset 0px -1px 0px rgba(0, 0, 0, 0.1); border-radius: 6px; margin-bottom: 20px;} #wccIABSectionVendor .wcc-accordion-body .wcc-child-accordion{padding-bottom: 10px;}.wcc-child-accordion .wcc-child-accordion-item{display: flex; padding: 15px 0; cursor: pointer;}.wcc-accordion-body .wcc-child-accordion.wcc-accordion-active{padding: 0 15px 15px;}.wcc-child-accordion.wcc-accordion-active .wcc-child-accordion-item{padding: 15px 0 0;}.wcc-child-accordion-chevron{margin-right: 18px; position: relative; cursor: pointer;}.wcc-child-accordion .wcc-child-accordion-chevron i::before{content: \"\"; position: absolute; border-right: 1.4px solid; border-bottom: 1.4px solid; border-color: #212121; height: 6px; width: 6px; -webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg); transition: all 0.2s ease-in-out; top: 8px;}.wcc-child-accordion.wcc-accordion-active .wcc-child-accordion-chevron i::before{top: 6px; -webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg);}.wcc-child-accordion-item .wcc-child-accordion-header-wrapper{display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; width: 100%; cursor:default;}.wcc-child-accordion-header-wrapper .wcc-child-accordion-btn{color: #212121; font-weight: 700; text-align: left;}.wcc-child-accordion-header-wrapper .wcc-switch-wrapper{color: #212121; display: flex; align-items: center; justify-content: end; flex-wrap: wrap;}.wcc-switch-wrapper .wcc-legitimate-switch-wrapper,.wcc-switch-wrapper .wcc-consent-switch-wrapper{display: flex; align-items: center; justify-content: center;}.wcc-legitimate-switch-wrapper.wcc-switch-separator{border-right: 1px solid #d0d5d2; padding: 0 10px 0 0;}.wcc-switch-wrapper .wcc-consent-switch-wrapper{padding: 0 0 0 10px;}.wcc-legitimate-switch-wrapper .wcc-switch-label,.wcc-consent-switch-wrapper .wcc-switch-label{font-size: 14px; line-height: 24px; margin: 0 8px 0 0;}.wcc-switch-sm{display: flex;}.wcc-switch-sm input[type=\"checkbox\"]{position: relative; width: 34px; height: 20px; margin: 0; background: #d0d5d2; -webkit-appearance: none; border-radius: 50px; cursor: pointer; outline: 0; border: none; top: 0;}.wcc-switch-sm input[type=\"checkbox\"]:checked{background: #1863dc;}.wcc-switch-sm input[type=\"checkbox\"]:before{position: absolute; content: \"\"; height: 16px; width: 16px; left: 2px; bottom: 2px; border-radius: 50%; background-color: white; -webkit-transition: 0.4s; transition: 0.4s; margin: 0;}.wcc-switch-sm input[type=\"checkbox\"]:checked:before{-webkit-transform: translateX(14px); -ms-transform: translateX(14px); transform: translateX(14px);}.wcc-switch-sm input[type=\"checkbox\"]:focus-visible{outline: 2px solid #1863dc; outline-offset: 2px;}.wcc-child-accordion .wcc-child-accordion-body,.wcc-preference-body-wrapper .wcc-iab-detail-title{display: none;}.wcc-child-accordion.wcc-accordion-active .wcc-child-accordion-body{display: block;}.wcc-accordion-iab-item .wcc-accordion-btn{color: inherit;}.wcc-child-accordion-body .wcc-iab-ad-settings-details{color: #212121; font-size: 12px; line-height: 24px; margin: 0 0 0 18px;}.wcc-child-accordion-body .wcc-iab-ad-settings-details *{font-size: 12px; line-height: 24px; word-wrap: break-word;}.wcc-iab-ad-settings-details .wcc-vendor-wrapper{color: #212121;}.wcc-iab-ad-settings-details .wcc-iab-ad-settings-details-des,.wcc-iab-ad-settings-details .wcc-vendor-privacy-link{margin: 13px 0 11px;}.wcc-iab-illustrations p,.wcc-iab-illustrations .wcc-iab-illustrations-des{margin: 0;}.wcc-iab-illustrations .wcc-iab-illustrations-title,.wcc-vendor-privacy-link .wcc-vendor-privacy-link-title,.wcc-vendor-legitimate-link .wcc-vendor-legitimate-link-title{font-weight: 700;}.wcc-vendor-privacy-link .external-link-img,.wcc-vendor-legitimate-link .external-link-img{display: inline-block; vertical-align: text-top;}.wcc-iab-illustrations .wcc-iab-illustrations-des{padding: 0 0 0 24px;}.wcc-iab-ad-settings-details .wcc-iab-vendors-count-wrapper{font-weight: 700; margin: 11px 0 0;}.wcc-vendor-wrapper .wcc-vendor-data-retention-section,.wcc-vendor-wrapper .wcc-vendor-purposes-section,.wcc-vendor-wrapper .wcc-vendor-special-purposes-section,.wcc-vendor-wrapper .wcc-vendor-features-section,.wcc-vendor-wrapper .wcc-vendor-special-features-section,.wcc-vendor-wrapper .wcc-vendor-categories-section,.wcc-vendor-wrapper .wcc-vendor-storage-overview-section,.wcc-vendor-wrapper .wcc-vendor-storage-disclosure-section,.wcc-vendor-wrapper .wcc-vendor-legitimate-link{margin: 11px 0;}.wcc-vendor-privacy-link a,.wcc-vendor-legitimate-link a{text-decoration: none; color: #1863dc;}.wcc-vendor-data-retention-section .wcc-vendor-data-retention-value,.wcc-vendor-purposes-section .wcc-vendor-purposes-title,.wcc-vendor-special-purposes-section .wcc-vendor-special-purposes-title,.wcc-vendor-features-section .wcc-vendor-features-title,.wcc-vendor-special-features-section .wcc-vendor-special-features-title,.wcc-vendor-categories-section .wcc-vendor-categories-title,.wcc-vendor-storage-overview-section .wcc-vendor-storage-overview-title{font-weight: 700; margin: 0;}.wcc-vendor-storage-disclosure-section .wcc-vendor-storage-disclosure-title{font-weight: 700; margin: 0 0 11px;}.wcc-vendor-data-retention-section .wcc-vendor-data-retention-list,.wcc-vendor-purposes-section .wcc-vendor-purposes-list,.wcc-vendor-special-purposes-section .wcc-vendor-special-purposes-list,.wcc-vendor-features-section .wcc-vendor-features-list,.wcc-vendor-special-features-section .wcc-vendor-special-features-list,.wcc-vendor-categories-section .wcc-vendor-categories-list,.wcc-vendor-storage-overview-section .wcc-vendor-storage-overview-list,.wcc-vendor-storage-disclosure-section .wcc-vendor-storage-disclosure-list{margin: 0; padding: 0 0 0 18px;}.wcc-cookie-des-table .wcc-purposes-list{padding: 0 0 0 12px; margin: 0;}.wcc-cookie-des-table .wcc-purposes-list li{display: list-item; list-style-type: disc;}.wcc-vendor-wrapper .wcc-show-table-btn{font-size: 12px; color: #1863dc;}.wcc-vendor-wrapper .wcc-loader,.wcc-vendor-wrapper .wcc-error-msg{margin: 0;}.wcc-vendor-wrapper .wcc-error-msg{color: #e71d36;}.wcc-audit-table.wcc-vendor-audit-table{background-color: #ffffff; border-color: #f4f4f4;}.wcc-audit-table.wcc-vendor-audit-table .wcc-cookie-des-table li div:first-child{width: 200px;}button.wcc-iab-dec-btn:focus-visible,button.wcc-child-accordion-btn:focus-visible,button.wcc-show-table-btn:focus-visible,button.wcc-iab-nav-btn:focus-visible,.wcc-vendor-privacy-link a:focus-visible,.wcc-vendor-legitimate-link a:focus-visible{outline: 2px solid #1863dc; outline-offset: 2px;}button.wcc-iab-dec-btn:not(:hover):not(:active),button.wcc-iab-nav-btn:not(:hover):not(:active),button.wcc-child-accordion-btn:not(:hover):not(:active),button.wcc-show-table-btn:not(:hover):not(:active),.wcc-vendor-privacy-link a:not(:hover):not(:active),.wcc-vendor-legitimate-link a:not(:hover):not(:active){background: transparent;}.wcc-accordion-iab-item button.wcc-accordion-btn:not(:hover):not(:active){color: inherit;}button.wcc-iab-nav-btn:not(:hover):not(:active){color: #757575;}button.wcc-iab-dec-btn:not(:hover):not(:active),.wcc-iab-nav-item.wcc-iab-nav-item-active button.wcc-iab-nav-btn:not(:hover):not(:active),button.wcc-show-table-btn:not(:hover):not(:active){color: #1863dc;}button.wcc-child-accordion-btn:not(:hover):not(:active){color: #212121;}button.wcc-iab-nav-btn:focus:not(:focus-visible),button.wcc-iab-dec-btn:focus:not(:focus-visible),button.wcc-child-accordion-btn:focus:not(:focus-visible),button.wcc-show-table-btn:focus:not(:focus-visible){outline: 0;}.wcc-switch-sm input[type=\"checkbox\"]:after{display: none;}@media (max-width: 768px){.wcc-child-accordion-header-wrapper .wcc-switch-wrapper{width: 100%;}}@media (max-width: 576px){.wcc-hide-ad-settings{display: block;}.wcc-iab-detail-wrapper{display: block; flex: 1; overflow: auto; border-color: inherit;}.wcc-iab-detail-wrapper .wcc-iab-navbar-wrapper{display: none;}.wcc-iab-detail-sub-wrapper .wcc-preference-body-wrapper{border-top: 1px solid; border-color: inherit;}.wcc-preference-body-wrapper .wcc-iab-detail-title{display: block; font-size: 16px; font-weight: 700; margin: 10px 0 0; line-height: 24px;}.wcc-audit-table.wcc-vendor-audit-table .wcc-cookie-des-table li div:first-child{width: 100px;}}@media (max-width: 425px){.wcc-switch-sm input[type=\"checkbox\"]{width: 25px; height: 16px;}.wcc-switch-sm input[type=\"checkbox\"]:before{height: 12px; width: 12px;}.wcc-switch-sm input[type=\"checkbox\"]:checked:before{-webkit-transform: translateX(9px); -ms-transform: translateX(9px); transform: translateX(9px);}.wcc-child-accordion-chevron{margin-right: 15px;}.wcc-child-accordion-body .wcc-iab-ad-settings-details{margin: 0 0 0 15px;}}@media (max-width: 352px){.wcc-iab-detail-wrapper .wcc-iab-preference-des, .wcc-child-accordion-header-wrapper .wcc-child-accordion-btn, .wcc-legitimate-switch-wrapper .wcc-switch-label, .wcc-consent-switch-wrapper .wcc-switch-label, button.wcc-iab-dec-btn{font-size: 12px;}.wcc-preference-body-wrapper .wcc-iab-detail-title{font-size: 14px;}}.wcc-rtl .wcc-child-accordion .wcc-child-accordion-chevron i::before{border: none; border-left: 1.4px solid; border-top: 1.4px solid; left: 12px;}.wcc-rtl .wcc-child-accordion.wcc-accordion-active .wcc-child-accordion-chevron i::before{-webkit-transform: rotate(-135deg); -moz-transform: rotate(-135deg); -ms-transform: rotate(-135deg); -o-transform: rotate(-135deg); transform: rotate(-135deg);}.wcc-rtl .wcc-child-accordion-body .wcc-iab-ad-settings-details{margin: 0 18px 0 0;}.wcc-rtl .wcc-iab-illustrations .wcc-iab-illustrations-des{padding: 0 24px 0 0;}.wcc-rtl .wcc-consent-switch-wrapper .wcc-switch-label,.wcc-rtl .wcc-legitimate-switch-wrapper .wcc-switch-label{margin: 0 0 0 8px;}.wcc-rtl .wcc-switch-wrapper .wcc-legitimate-switch-wrapper{padding: 0; border-right: none;}.wcc-rtl .wcc-legitimate-switch-wrapper.wcc-switch-separator{border-left: 1px solid #d0d5d2; padding: 0 0 0 10px;}.wcc-rtl .wcc-switch-wrapper .wcc-consent-switch-wrapper{padding: 0 10px 0 0;}.wcc-rtl .wcc-child-accordion-header-wrapper .wcc-child-accordion-btn{text-align: right;}.wcc-rtl .wcc-vendor-data-retention-section .wcc-vendor-data-retention-list,.wcc-rtl .wcc-vendor-purposes-section .wcc-vendor-purposes-list,.wcc-rtl .wcc-vendor-special-purposes-section .wcc-vendor-special-purposes-list,.wcc-rtl .wcc-vendor-features-section .wcc-vendor-features-list,.wcc-rtl .wcc-vendor-special-features-section .wcc-vendor-special-features-list,.wcc-rtl .wcc-vendor-categories-section .wcc-vendor-categories-list,.wcc-rtl .wcc-vendor-storage-overview-section .wcc-vendor-storage-overview-list,.wcc-rtl .wcc-vendor-storage-disclosure-section .wcc-vendor-storage-disclosure-list{padding: 0 18px 0 0;}@media (max-width: 425px){.wcc-rtl .wcc-child-accordion-body .wcc-iab-ad-settings-details{margin: 0 15px 0 0;}}"}};
var _wccApi = {"base":"https:\/\/www.fidelitybank.ng\/wp-json\/wcc\/v1\/","nonce":"ceb30a36c7"};
</script>
<script src="/wp-content/plugins/webtoffee-cookie-consent/lite/frontend/js/script.min.js?ver=3.1.0" id="webtoffee-cookie-consent-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="https://www.fidelitybank.ng/wp-includes/js/jquery/jquery.min.js?ver=3.7.1" id="jquery-core-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="https://www.fidelitybank.ng/wp-includes/js/jquery/jquery-migrate.min.js?ver=3.4.1" id="jquery-migrate-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementor/assets/lib/font-awesome/js/v4-shims.min.js?ver=3.25.8" id="font-awesome-4-shim-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="ecs_ajax_load-js-extra" type="4364f5cca7525295a0b533ca-text/javascript">
var ecs_ajax_params = {"ajaxurl":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php","posts":"{\"page\":0,\"pagename\":\"treasury-and-investment\",\"error\":\"\",\"m\":\"\",\"p\":0,\"post_parent\":\"\",\"subpost\":\"\",\"subpost_id\":\"\",\"attachment\":\"\",\"attachment_id\":0,\"name\":\"treasury-and-investment\",\"page_id\":0,\"second\":\"\",\"minute\":\"\",\"hour\":\"\",\"day\":0,\"monthnum\":0,\"year\":0,\"w\":0,\"category_name\":\"\",\"tag\":\"\",\"cat\":\"\",\"tag_id\":\"\",\"author\":\"\",\"author_name\":\"\",\"feed\":\"\",\"tb\":\"\",\"paged\":0,\"meta_key\":\"\",\"meta_value\":\"\",\"preview\":\"\",\"s\":\"\",\"sentence\":\"\",\"title\":\"\",\"fields\":\"\",\"menu_order\":\"\",\"embed\":\"\",\"category__in\":[],\"category__not_in\":[],\"category__and\":[],\"post__in\":[],\"post__not_in\":[],\"post_name__in\":[],\"tag__in\":[],\"tag__not_in\":[],\"tag__and\":[],\"tag_slug__in\":[],\"tag_slug__and\":[],\"post_parent__in\":[],\"post_parent__not_in\":[],\"author__in\":[],\"author__not_in\":[],\"search_columns\":[],\"post_type\":[\"post\",\"page\",\"e-landing-page\"],\"ignore_sticky_posts\":false,\"suppress_filters\":false,\"cache_results\":true,\"update_post_term_cache\":true,\"update_menu_item_cache\":false,\"lazy_load_term_meta\":true,\"update_post_meta_cache\":true,\"posts_per_page\":10,\"nopaging\":false,\"comments_per_page\":\"50\",\"no_found_rows\":false,\"order\":\"DESC\"}"};
</script>
<script src="/wp-content/plugins/ele-custom-skin/assets/js/ecs_ajax_pagination.js?ver=3.1.9" id="ecs_ajax_load-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/ele-custom-skin/assets/js/ecs.js?ver=3.1.9" id="ecs-script-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<link rel="https://api.w.org/" href="https://www.fidelitybank.ng/wp-json/" /><link rel="alternate" title="JSON" type="application/json" href="https://www.fidelitybank.ng/wp-json/wp/v2/pages/15256" /><style id="wcc-style-inline">[data-tag]{visibility:hidden;}</style><script data-cfasync="false"> var dearPdfLocation = "/wp-content/plugins/dearpdf-pro/assets/"; var dearpdfWPGlobal = {"text":{"blank":""},"viewerType":"flipbook","is3D":true,"pageScale":"auto","height":"auto","mobileViewerType":"auto","backgroundColor":"transparent","backgroundImage":"","showDownloadControl":true,"sideMenuOverlay":true,"readDirection":"ltr","disableRange":false,"has3DCover":true,"enableSound":true,"color3DCover":"#002082","controlsPosition":"bottom","rangeChunkSize":"524288","maxTextureSize":"3200","pageMode":"auto","singlePageMode":"auto","pdfVersion":"default","autoPDFLinktoViewer":false,"attachmentLightbox":"true","duration":"800","paddingLeft":"15","paddingRight":"15","paddingTop":"20","paddingBottom":"20","moreControls":"download,pageMode,startPage,endPage,sound","hideControls":""};</script><meta name="generator" content="Elementor 3.25.8; features: additional_custom_breakpoints, e_optimized_control_loading; settings: css_print_method-internal, google_font-enabled, font_display-auto">
<style>

		.page-header .entry-title {
			display: none !important;
		}
	
	  .elementor-widget:not(:last-child) {
    	margin-bottom: 0px !important;
		}
	
		.moove-gdpr-branding-cnt {
    	display: none !important;
		}
	
		#moove_gdpr_cookie_info_bar .moove-gdpr-info-bar-container .moove-gdpr-info-bar-content p, #moove_gdpr_cookie_info_bar .moove-gdpr-info-bar-container .moove-gdpr-info-bar-content p a {
    	font-size: 15px;
			font-weight: 500;
		}

</style>

			<style>
				.e-con.e-parent:nth-of-type(n+4):not(.e-lazyloaded):not(.e-no-lazyload),
				.e-con.e-parent:nth-of-type(n+4):not(.e-lazyloaded):not(.e-no-lazyload) * {
					background-image: none !important;
				}
				@media screen and (max-height: 1024px) {
					.e-con.e-parent:nth-of-type(n+3):not(.e-lazyloaded):not(.e-no-lazyload),
					.e-con.e-parent:nth-of-type(n+3):not(.e-lazyloaded):not(.e-no-lazyload) * {
						background-image: none !important;
					}
				}
				@media screen and (max-height: 640px) {
					.e-con.e-parent:nth-of-type(n+2):not(.e-lazyloaded):not(.e-no-lazyload),
					.e-con.e-parent:nth-of-type(n+2):not(.e-lazyloaded):not(.e-no-lazyload) * {
						background-image: none !important;
					}
				}
			</style>
			<meta name="generator" content="Powered by Slider Revolution 6.7.21 - responsive, Mobile-Friendly Slider Plugin for WordPress with comfortable drag and drop interface." />
<link rel="icon" href="/wp-content/uploads/2020/08/Fidelity-Bank-Icon-FAV-1-1.svg" sizes="32x32" />
<link rel="icon" href="/wp-content/uploads/2020/08/Fidelity-Bank-Icon-FAV-1-1.svg" sizes="192x192" />
<link rel="apple-touch-icon" href="/wp-content/uploads/2020/08/Fidelity-Bank-Icon-FAV-1-1.svg" />
<meta name="msapplication-TileImage" content="/wp-content/uploads/2020/08/Fidelity-Bank-Icon-FAV-1-1.svg" />
<script type="4364f5cca7525295a0b533ca-text/javascript">function setREVStartSize(e){
			//window.requestAnimationFrame(function() {
				window.RSIW = window.RSIW===undefined ? window.innerWidth : window.RSIW;
				window.RSIH = window.RSIH===undefined ? window.innerHeight : window.RSIH;
				try {
					var pw = document.getElementById(e.c).parentNode.offsetWidth,
						newh;
					pw = pw===0 || isNaN(pw) || (e.l=="fullwidth" || e.layout=="fullwidth") ? window.RSIW : pw;
					e.tabw = e.tabw===undefined ? 0 : parseInt(e.tabw);
					e.thumbw = e.thumbw===undefined ? 0 : parseInt(e.thumbw);
					e.tabh = e.tabh===undefined ? 0 : parseInt(e.tabh);
					e.thumbh = e.thumbh===undefined ? 0 : parseInt(e.thumbh);
					e.tabhide = e.tabhide===undefined ? 0 : parseInt(e.tabhide);
					e.thumbhide = e.thumbhide===undefined ? 0 : parseInt(e.thumbhide);
					e.mh = e.mh===undefined || e.mh=="" || e.mh==="auto" ? 0 : parseInt(e.mh,0);
					if(e.layout==="fullscreen" || e.l==="fullscreen")
						newh = Math.max(e.mh,window.RSIH);
					else{
						e.gw = Array.isArray(e.gw) ? e.gw : [e.gw];
						for (var i in e.rl) if (e.gw[i]===undefined || e.gw[i]===0) e.gw[i] = e.gw[i-1];
						e.gh = e.el===undefined || e.el==="" || (Array.isArray(e.el) && e.el.length==0)? e.gh : e.el;
						e.gh = Array.isArray(e.gh) ? e.gh : [e.gh];
						for (var i in e.rl) if (e.gh[i]===undefined || e.gh[i]===0) e.gh[i] = e.gh[i-1];
											
						var nl = new Array(e.rl.length),
							ix = 0,
							sl;
						e.tabw = e.tabhide>=pw ? 0 : e.tabw;
						e.thumbw = e.thumbhide>=pw ? 0 : e.thumbw;
						e.tabh = e.tabhide>=pw ? 0 : e.tabh;
						e.thumbh = e.thumbhide>=pw ? 0 : e.thumbh;
						for (var i in e.rl) nl[i] = e.rl[i]<window.RSIW ? 0 : e.rl[i];
						sl = nl[0];
						for (var i in nl) if (sl>nl[i] && nl[i]>0) { sl = nl[i]; ix=i;}
						var m = pw>(e.gw[ix]+e.tabw+e.thumbw) ? 1 : (pw-(e.tabw+e.thumbw)) / (e.gw[ix]);
						newh =  (e.gh[ix] * m) + (e.tabh + e.thumbh);
					}
					var el = document.getElementById(e.c);
					if (el!==null && el) el.style.height = newh+"px";
					el = document.getElementById(e.c+"_wrapper");
					if (el!==null && el) {
						el.style.height = newh+"px";
						el.style.display = "block";
					}
				} catch(e){
					console.log("Failure at Presize of Slider:" + e)
				}
			//});
		  };</script>

	<!-- Netcore Web Integration -->
	<script src='//cdnt.netcoresmartech.com/smartechclient.js' type="4364f5cca7525295a0b533ca-text/javascript"></script>
	<script type="4364f5cca7525295a0b533ca-text/javascript">
	smartech('create', 'ADGMOT35CHFLVDHBJNIG50K968LM8TT9J16L7LOFKJ75EMGD0SA0' );
	smartech('register', '3fb28fdf3e445c9422f12b4f50ab0848');
	smartech('identify', '');
	</script>

	<!-- Google tag (gtag.js) -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=G-Q351SFPM7R" type="4364f5cca7525295a0b533ca-text/javascript"></script>
	<script type="4364f5cca7525295a0b533ca-text/javascript">
  	window.dataLayer = window.dataLayer || [];
  	function gtag(){dataLayer.push(arguments);}
  	gtag('js', new Date());

  	gtag('config', 'G-Q351SFPM7R');
	</script>
	
	<!-- Google Tag Manager -->
	<script type="4364f5cca7525295a0b533ca-text/javascript">(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
	new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
	j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
	'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
	})(window,document,'script','dataLayer','GTM-PR6H8LN');</script>
	<!-- End Google Tag Manager -->

	<!-- Facebook Pixel Code -->
	<script type="4364f5cca7525295a0b533ca-text/javascript">
	!function(f,b,e,v,n,t,s)
	{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
	n.callMethod.apply(n,arguments):n.queue.push(arguments)};
	if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
	n.queue=[];t=b.createElement(e);t.async=!0;
	t.src=v;s=b.getElementsByTagName(e)[0];
	s.parentNode.insertBefore(t,s)}(window,document,'script',
	'https://avanan.url-protection.com/v1/url?o=https%3A//connect.facebook.net/en_US/fbevents.js%26%23039&g=ZTE4NDFkZDRlZDRhODFmMQ==&h=YWRkZjUxMWY5MzgxOWMyNDQ5OWEyMDFkNDU1OThlNjU3NDYzMjY5ZjVhMDA3MWM1YzI0MDFiZGRmNmY0OTY4Yw==&p=YXAzOmZpZGVsaXR5YmFua25pZ2VyaWE6YTpvOmE4MDU2NjcyN2QwZWE2ZTFkOGMwNDBjYjRiYmYyNjQ0OnYxOnQ6Tg==;);
	fbq('init', '614651892971462'); 
	fbq('track', 'PageView');
	</script>
	<noscript>
	<img height="1" width="1" 
	src="https://avanan.url-protection.com/v1/url?o=https%3A//www.facebook.com/tr%3Fid%3D614651892971462%26amp%3Bev%3DPageView&g=ZmVmNDMxNjMzZmU5NDI0NQ==&h=ZjFkMmRlY2U3MjcxZDZkYThmYjNmMjNhMTY3YmJiNTFjM2FkMTI3YzRjOTI5YzcwZWNhOTU3M2I4OTY3ZTFiNA==&p=YXAzOmZpZGVsaXR5YmFua25pZ2VyaWE6YTpvOmE4MDU2NjcyN2QwZWE2ZTFkOGMwNDBjYjRiYmYyNjQ0OnYxOnQ6Tg==
	&noscript=1"/>
	</noscript>
	<!-- End Facebook Pixel Code -->
</head>
<body data-rsssl=1 class="page-template-default page page-id-15256 page-parent wp-custom-logo elementor-default elementor-kit-28996 elementor-page elementor-page-15256">

<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-PR6H8LN"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->


<a class="skip-link screen-reader-text" href="#content">Skip to content</a>

		<div data-elementor-type="header" data-elementor-id="9384" class="elementor elementor-9384 elementor-location-header" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementor_library">
					<header class="elementor-section elementor-top-section elementor-element elementor-element-48f0dd05 elementor-section-content-middle elementor-section-stretched elementor-section-height-min-height elementor-section-full_width elementor-section-height-default elementor-section-items-middle" data-id="48f0dd05" data-element_type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;sticky&quot;:&quot;top&quot;,&quot;stretch_section&quot;:&quot;section-stretched&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;e878d3f&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}],&quot;sticky_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;,&quot;mobile&quot;],&quot;sticky_offset&quot;:0,&quot;sticky_effects_offset&quot;:0,&quot;sticky_anchor_link_offset&quot;:0}">
						<div class="elementor-container elementor-column-gap-no">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-5fc7518" data-id="5fc7518" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<section class="elementor-section elementor-inner-section elementor-element elementor-element-502e850 elementor-section-content-middle elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="502e850" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;2984870&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-no">
					<div class="elementor-column elementor-col-16 elementor-inner-column elementor-element elementor-element-fa799f9" data-id="fa799f9" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-2155c0fb elementor-align-left elementor-tablet-align-right elementor-hidden-mobile elementor-hidden-desktop elementor-widget elementor-widget-button" data-id="2155c0fb" data-element_type="widget" data-widget_type="button.default">
				<div class="elementor-widget-container">
							<div class="elementor-button-wrapper">
					<a class="elementor-button elementor-button-link elementor-size-sm" href="#elementor-action%3Aaction%3Dpopup%3Aopen%26settings%3DeyJpZCI6IjM3NDEwIiwidG9nZ2xlIjpmYWxzZX0%3D">
						<span class="elementor-button-content-wrapper">
						<span class="elementor-button-icon">
				<i aria-hidden="true" class="zmdi zmdi-lock"></i>			</span>
									<span class="elementor-button-text">ONLINE BANKING</span>
					</span>
					</a>
				</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-efbe71a elementor-hidden-tablet elementor-hidden-mobile elementor-widget elementor-widget-ekit-nav-menu" data-id="efbe71a" data-element_type="widget" data-widget_type="ekit-nav-menu.default">
				<div class="elementor-widget-container">
					<nav class="ekit-wid-con ekit_menu_responsive_tablet" 
			data-hamburger-icon="" 
			data-hamburger-icon-type="icon" 
			data-responsive-breakpoint="1024">
			            <button class="elementskit-menu-hamburger elementskit-menu-toggler"  type="button" aria-label="hamburger-icon">
                                    <span class="elementskit-menu-hamburger-icon"></span><span class="elementskit-menu-hamburger-icon"></span><span class="elementskit-menu-hamburger-icon"></span>
                            </button>
            <style id="elementor-post-37332">.elementor-37332 .elementor-element.elementor-element-00227dd:not(.elementor-motion-effects-element-type-background) > .elementor-widget-wrap, .elementor-37332 .elementor-element.elementor-element-00227dd > .elementor-widget-wrap > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:var( --e-global-color-accent );}.elementor-37332 .elementor-element.elementor-element-00227dd > .elementor-element-populated{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;margin:-2px 0px 0px -2px;--e-column-margin-right:0px;--e-column-margin-left:-2px;padding:20px 20px 20px 20px;}.elementor-37332 .elementor-element.elementor-element-00227dd > .elementor-element-populated > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-nav .elementkit-nav-link.active{background-color:#FFFFFF4D;color:var( --e-global-color-db9a681 );}.elementor-37332 .elementor-element.elementor-element-3f7a782 .tab-content .tab-pane{background-color:#FFFFFF4D;color:#FFFFFF;padding:15px 10px 15px 10px;border-radius:0px 0px 4px 4px;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-wraper .elementkit-nav-link.left-pos .elementskit-tab-icon{margin-right:10px;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-wraper .elementkit-nav-link.left-pos .ekit-icon-image{margin-right:10px;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-wraper .elementkit-nav-link{justify-content:center;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-nav{padding:0px 0px 0px 0px;margin:0px 0px 0px 0px;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-nav .elementkit-nav-item .elementkit-nav-link{font-size:13px;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-wraper:not(.vertical) .elementkit-nav-item:not(:last-child){margin-right:10px;}.rtl .elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-wraper:not(.vertical) .elementkit-nav-item:not(:last-child){margin-left:10px;margin-right:0;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-wraper.vertical .elementkit-tab-nav{margin-right:10px;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-wraper.vertical .elementkit-nav-item:not(:last-child){margin-bottom:0px;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-wraper:not(.vertical) .elementkit-tab-nav{margin-bottom:0px;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-nav .elementkit-nav-link{padding:12px 35px 12px 35px;color:#333333;border-style:solid;border-width:1px 1px 1px 1px;border-color:#2575FC00;}.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-nav .elementkit-nav-item a.elementkit-nav-link{border-radius:4px 4px 0px 0px;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(max-width:1024px){.elementor-37332 .elementor-element.elementor-element-3f7a782 .elementkit-tab-nav{padding:0px 0px 0px 0px;margin:0px 0px 0px 0px;}}@media(max-width:767px){.elementor-37332 .elementor-element.elementor-element-00227dd > .elementor-element-populated{padding:20px 10px 20px 10px;}}</style><div id="ekit-megamenu-online-banking" class="elementskit-menu-container elementskit-menu-offcanvas-elements elementskit-navbar-nav-default ekit-nav-menu-one-page-no ekit-nav-dropdown-hover"><ul id="menu-online-banking" class="elementskit-navbar-nav elementskit-menu-po-center submenu-click-on-icon"><li id="menu-item-37327" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-37327 nav-item elementskit-dropdown-has relative_position elementskit-dropdown-menu-default_width elementskit-megamenu-has elementskit-mobile-builder-content" data-vertical-menu=750px><a href="#" class="ekit-menu-nav-link"><span>Online Banking</span><i class="_mi _after dashicons dashicons-lock" aria-hidden="true"></i><i aria-hidden="true" class="icon icon-none elementskit-submenu-indicator"></i></a><div class="elementskit-megamenu-panel">		<div data-elementor-type="wp-post" data-elementor-id="37332" class="elementor elementor-37332" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementskit_content">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-a994953 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="a994953" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-00227dd" data-id="00227dd" data-element_type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-3f7a782 elementor-widget elementor-widget-elementskit-simple-tab" data-id="3f7a782" data-element_type="widget" data-widget_type="elementskit-simple-tab.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" >        <div class="elementkit-tab-wraper  ">
            <ul class="nav nav-tabs elementkit-tab-nav  elementskit-fullwidth-tab">
                                    <li class="elementkit-nav-item elementor-repeater-item-1ec743b">
                        <a class="elementkit-nav-link  active show left-pos" id="content-1ec743b673c8ad7993f1-tab" data-ekit-handler-id="personal" data-ekit-toggle="tab" data-target="#content-1ec743b673c8ad7993f1" href="#Content-1ec743b673c8ad7993f1"
                            data-ekit-toggle-trigger="click"
                            aria-describedby="Content-1ec743b673c8ad7993f1">
                                                        <span class="elementskit-tab-title"> Personal</span>
                        </a>
                    </li>
                                        <li class="elementkit-nav-item elementor-repeater-item-73acd0a">
                        <a class="elementkit-nav-link  left-pos" id="content-73acd0a673c8ad7993f1-tab" data-ekit-handler-id="corporate" data-ekit-toggle="tab" data-target="#content-73acd0a673c8ad7993f1" href="#Content-73acd0a673c8ad7993f1"
                            data-ekit-toggle-trigger="click"
                            aria-describedby="Content-73acd0a673c8ad7993f1">
                                                        <span class="elementskit-tab-title"> Corporate</span>
                        </a>
                    </li>
                                </ul>

            <div class="tab-content elementkit-tab-content">
                                    <div class="tab-pane elementkit-tab-pane elementor-repeater-item-1ec743b  active show" id="content-1ec743b673c8ad7993f1" role="tabpanel"
                         aria-labelledby="content-1ec743b673c8ad7993f1-tab">
                        <div class="animated fadeIn">
                            <style id="elementor-post-37365">.elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn{background-color:#002082;width:100%;padding:17px 17px 17px 17px;font-size:12px;font-weight:600;text-transform:uppercase;color:#FFFFFF;border-style:none;border-radius:4px 4px 4px 4px;box-shadow:3px 4px 10px 0px rgba(61.500000000000014, 61.500000000000014, 61.500000000000014, 0.89);}.elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn:hover{background-color:#0028A1;color:#ffffff;}.elementor-37365 .elementor-element.elementor-element-c272d34 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-37365 .elementor-element.elementor-element-c272d34 .ekit-btn-wraper{text-align:center;}.elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn svg path{stroke:#FFFFFF;fill:#FFFFFF;}.elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn:hover svg path{stroke:#ffffff;fill:#ffffff;}.elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn > i, .elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn > svg{margin-right:4px;}.rtl .elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn > i, .rtl .elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn > svg{margin-left:4px;margin-right:0;}.elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn i, .elementor-37365 .elementor-element.elementor-element-c272d34 .elementskit-btn svg{-webkit-transform:translateY(-2px);-ms-transform:translateY(-2px);transform:translateY(-2px);}.elementor-37365 .elementor-element.elementor-element-b678a70 .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-37365 .elementor-element.elementor-element-b678a70 .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-37365 .elementor-element.elementor-element-b678a70{--e-icon-list-icon-size:14px;--icon-vertical-offset:0px;}.elementor-37365 .elementor-element.elementor-element-b678a70 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-37365 .elementor-element.elementor-element-b678a70 .elementor-icon-list-item > a{font-size:12px;font-weight:600;}.elementor-37365 .elementor-element.elementor-element-b678a70 .elementor-icon-list-text{color:#333333;transition:color 0.3s;}.elementor-37365 .elementor-element.elementor-element-b678a70 .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}@media(max-width:767px){.elementor-37365 .elementor-element.elementor-element-031c722 > .elementor-element-populated{padding:0px 0px 0px 0px;}}</style>		<div data-elementor-type="section" data-elementor-id="37365" class="elementor elementor-37365 elementor-location-header" data-elementor-post-type="elementor_library">
					<section class="elementor-section elementor-top-section elementor-element elementor-element-3bfca37 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="3bfca37" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-031c722" data-id="031c722" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-c272d34 elementor-widget elementor-widget-elementskit-button" data-id="c272d34" data-element_type="widget" data-widget_type="elementskit-button.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" >		<div class="ekit-btn-wraper">
							<a href="https://online.fidelitybank.ng" class="elementskit-btn  whitespace--normal" id="">
					<i aria-hidden="true" class="icon- icon-lock"></i>Login				</a>
					</div>
        </div>		</div>
				</div>
				<div class="elementor-element elementor-element-b678a70 elementor-icon-list--layout-inline elementor-align-center elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="b678a70" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items elementor-inline-items">
							<li class="elementor-icon-list-item elementor-inline-item">
											<a href="https://online.fidelitybank.ng/#/reg/guide/RETAIL_REG_ONLINE">

											<span class="elementor-icon-list-text">Register</span>
											</a>
									</li>
								<li class="elementor-icon-list-item elementor-inline-item">
										<span class="elementor-icon-list-text">|</span>
									</li>
								<li class="elementor-icon-list-item elementor-inline-item">
											<a href="https://eserve.fidelitybank.ng/oap/">

											<span class="elementor-icon-list-text">Open New Account</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		                        </div>
                    </div>
                                    <div class="tab-pane elementkit-tab-pane elementor-repeater-item-73acd0a " id="content-73acd0a673c8ad7993f1" role="tabpanel"
                         aria-labelledby="content-73acd0a673c8ad7993f1-tab">
                        <div class="animated fadeIn">
                            <style id="elementor-post-37381">.elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn{background-color:#002082;width:100%;padding:17px 17px 17px 17px;font-size:12px;font-weight:600;text-transform:uppercase;color:#FFFFFF;border-style:none;border-radius:4px 4px 4px 4px;box-shadow:3px 4px 10px 0px rgba(61.500000000000014, 61.500000000000014, 61.500000000000014, 0.89);}.elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn:hover{background-color:#0028A1;color:#ffffff;}.elementor-37381 .elementor-element.elementor-element-c272d34 > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-37381 .elementor-element.elementor-element-c272d34 .ekit-btn-wraper{text-align:center;}.elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn svg path{stroke:#FFFFFF;fill:#FFFFFF;}.elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn:hover svg path{stroke:#ffffff;fill:#ffffff;}.elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn > i, .elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn > svg{margin-right:4px;}.rtl .elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn > i, .rtl .elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn > svg{margin-left:4px;margin-right:0;}.elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn i, .elementor-37381 .elementor-element.elementor-element-c272d34 .elementskit-btn svg{-webkit-transform:translateY(-2px);-ms-transform:translateY(-2px);transform:translateY(-2px);}.elementor-37381 .elementor-element.elementor-element-b678a70 .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-37381 .elementor-element.elementor-element-b678a70 .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-37381 .elementor-element.elementor-element-b678a70{--e-icon-list-icon-size:14px;--icon-vertical-offset:0px;}.elementor-37381 .elementor-element.elementor-element-b678a70 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-37381 .elementor-element.elementor-element-b678a70 .elementor-icon-list-item > a{font-size:12px;font-weight:600;}.elementor-37381 .elementor-element.elementor-element-b678a70 .elementor-icon-list-text{color:#333333;transition:color 0.3s;}.elementor-37381 .elementor-element.elementor-element-b678a70 .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(max-width:767px){.elementor-37381 .elementor-element.elementor-element-031c722 > .elementor-element-populated{padding:0px 0px 0px 0px;}}</style>		<div data-elementor-type="page" data-elementor-id="37381" class="elementor elementor-37381" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementor_library">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-3bfca37 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="3bfca37" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-031c722" data-id="031c722" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-c272d34 elementor-widget elementor-widget-elementskit-button" data-id="c272d34" data-element_type="widget" data-widget_type="elementskit-button.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" >		<div class="ekit-btn-wraper">
							<a href="https://conb.fidelitybank.ng" class="elementskit-btn  whitespace--normal" id="">
					<i aria-hidden="true" class="icon- icon-lock"></i>Login				</a>
					</div>
        </div>		</div>
				</div>
				<div class="elementor-element elementor-element-b678a70 elementor-icon-list--layout-inline elementor-align-center elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="b678a70" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items elementor-inline-items">
							<li class="elementor-icon-list-item elementor-inline-item">
											<a href="https://conb.fidelitybank.ng/#/reg/guide/RETAIL_REG_ONLINE">

											<span class="elementor-icon-list-text">Register</span>
											</a>
									</li>
								<li class="elementor-icon-list-item elementor-inline-item">
										<span class="elementor-icon-list-text">|</span>
									</li>
								<li class="elementor-icon-list-item elementor-inline-item">
											<a href="https://eserve.fidelitybank.ng/oap/">

											<span class="elementor-icon-list-text">Open New Account</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		                        </div>
                    </div>
                                
            </div>
                    </div>
    </div>		</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-3477379" data-id="3477379" data-element_type="column">
			<div class="elementor-widget-wrap">
							</div>
		</div>
					</div>
		</section>
				</div>
		</div></li>
</ul><div class="elementskit-nav-identity-panel">
				<div class="elementskit-site-title">
					<a class="elementskit-nav-logo" href="https://www.fidelitybank.ng" target="_self" rel="">
						<img src="" title="" alt="" />
					</a> 
				</div><button class="elementskit-menu-close elementskit-menu-toggler" type="button">X</button></div></div>			
			<div class="elementskit-menu-overlay elementskit-menu-offcanvas-elements elementskit-menu-toggler ekit-nav-menu--overlay"></div>        </nav>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-16 elementor-inner-column elementor-element elementor-element-38b914e" data-id="38b914e" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-1151dcc elementor-align-center elementor-tablet-align-right elementor-hidden-phone elementor-widget elementor-widget-button" data-id="1151dcc" data-element_type="widget" data-widget_type="button.default">
				<div class="elementor-widget-container">
							<div class="elementor-button-wrapper">
					<a class="elementor-button elementor-button-link elementor-size-sm" href="https://www.fidelitybank.ng/open-account/">
						<span class="elementor-button-content-wrapper">
									<span class="elementor-button-text">OPEN AN ACCOUNT</span>
					</span>
					</a>
				</div>
						</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-16 elementor-inner-column elementor-element elementor-element-703c7a3" data-id="703c7a3" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-0b338ae elementor-nav-menu--stretch elementor-nav-menu__text-align-center elementor-nav-menu--dropdown-tablet elementor-nav-menu--toggle elementor-nav-menu--burger elementor-widget elementor-widget-nav-menu" data-id="0b338ae" data-element_type="widget" data-settings="{&quot;full_width&quot;:&quot;stretch&quot;,&quot;submenu_icon&quot;:{&quot;value&quot;:&quot;&lt;i class=\&quot;\&quot;&gt;&lt;\/i&gt;&quot;,&quot;library&quot;:&quot;&quot;},&quot;layout&quot;:&quot;horizontal&quot;,&quot;toggle&quot;:&quot;burger&quot;}" data-widget_type="nav-menu.default">
				<div class="elementor-widget-container">
						<nav aria-label="Menu" class="elementor-nav-menu--main elementor-nav-menu__container elementor-nav-menu--layout-horizontal e--pointer-none">
				<ul id="menu-1-0b338ae" class="elementor-nav-menu"><li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home menu-item-16641"><a href="https://www.fidelitybank.ng/" class="elementor-item"><span class="visuallyhidden">Home</span><i class="_mi elusive el-icon-home" aria-hidden="true" style="vertical-align:bottom;"></i></a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10484"><a href="https://www.fidelitybank.ng/about-us/" class="elementor-item">About Us</a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-12781"><a href="https://www.fidelitybank.ng/investor-relations/" class="elementor-item">Investor Relations</a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-14396"><a href="https://www.fidelitybank.ng/agriculture-and-export/" class="elementor-item">Agric &#038; Export</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15895"><a href="https://www.fidelitybank.ng/agriculture-and-export/export-management-programme/" class="elementor-sub-item">Fidelity EMP</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-18834"><a href="https://www.fidelitybank.ng/agriculture-and-export/gallery-agriculture-and-export/" class="elementor-sub-item">Gallery</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-9400"><a href="https://www.fidelitybank.ng/csr" class="elementor-item">CSR</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10492"><a href="https://www.fidelitybank.ng/csr/health-social-welfare/" class="elementor-sub-item">Health &#038; Social Welfare</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10493"><a href="https://www.fidelitybank.ng/csr/education/" class="elementor-sub-item">Education</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10490"><a href="https://www.fidelitybank.ng/csr/youth-empowerment/" class="elementor-sub-item">Youth Empowerment</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10491"><a href="https://www.fidelitybank.ng/csr/environment/" class="elementor-sub-item">Environment</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10487"><a href="https://www.fidelitybank.ng/csr/sustainability/" class="elementor-sub-item">Sustainability</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-12780"><a href="https://www.fidelitybank.ng/blog/" class="elementor-item">Media</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-34221"><a href="https://www.fidelitybank.ng/media-centre/" class="elementor-sub-item">Media Centre</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-14389"><a href="https://www.fidelitybank.ng/gallery/" class="elementor-sub-item">Gallery</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15146"><a href="https://www.fidelitybank.ng/magazine-publication/" class="elementor-sub-item">Magazine Publication</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-14393"><a href="https://www.fidelitybank.ng/blog/" class="elementor-sub-item">Blog</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-49073"><a href="https://www.fidelitybank.ng/help-support/" class="elementor-item">Helpdesk</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-49106"><a href="https://www.fidelitybank.ng/help-support/" class="elementor-sub-item">Help &#038; Support</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-17947"><a href="https://www.fidelitybank.ng/contact-us/" class="elementor-sub-item">True Serve</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-49120"><a href="https://www.fidelitybank.ng/feedback/" class="elementor-sub-item">Voice of Customer</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-14395"><a href="https://www.fidelitybank.ng/branch-locator/" class="elementor-sub-item">Branch/ATM Locator</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-46014"><a href="https://www.fidelitybank.ng/careers/" class="elementor-sub-item">Careers</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-17945"><a href="https://www.fidelitybank.ng/shareholder-enquiry/" class="elementor-sub-item">Shareholder Enquiry</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15779"><a href="https://www.fidelitybank.ng/information-security/" class="elementor-sub-item">Information Security</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16511"><a href="https://www.fidelitybank.ng/contact-us/whistle-blowing/" class="elementor-sub-item">Whistle Blowing</a></li>
</ul>
</li>
</ul>			</nav>
					<div class="elementor-menu-toggle" role="button" tabindex="0" aria-label="Menu Toggle" aria-expanded="false">
			<i aria-hidden="true" role="presentation" class="elementor-menu-toggle__icon--open eicon-menu-bar"></i><i aria-hidden="true" role="presentation" class="elementor-menu-toggle__icon--close eicon-close"></i>			<span class="elementor-screen-only">Menu</span>
		</div>
					<nav class="elementor-nav-menu--dropdown elementor-nav-menu__container" aria-hidden="true">
				<ul id="menu-2-0b338ae" class="elementor-nav-menu"><li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home menu-item-16641"><a href="https://www.fidelitybank.ng/" class="elementor-item" tabindex="-1"><span class="visuallyhidden">Home</span><i class="_mi elusive el-icon-home" aria-hidden="true" style="vertical-align:bottom;"></i></a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10484"><a href="https://www.fidelitybank.ng/about-us/" class="elementor-item" tabindex="-1">About Us</a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-12781"><a href="https://www.fidelitybank.ng/investor-relations/" class="elementor-item" tabindex="-1">Investor Relations</a></li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-14396"><a href="https://www.fidelitybank.ng/agriculture-and-export/" class="elementor-item" tabindex="-1">Agric &#038; Export</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15895"><a href="https://www.fidelitybank.ng/agriculture-and-export/export-management-programme/" class="elementor-sub-item" tabindex="-1">Fidelity EMP</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-18834"><a href="https://www.fidelitybank.ng/agriculture-and-export/gallery-agriculture-and-export/" class="elementor-sub-item" tabindex="-1">Gallery</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-9400"><a href="https://www.fidelitybank.ng/csr" class="elementor-item" tabindex="-1">CSR</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10492"><a href="https://www.fidelitybank.ng/csr/health-social-welfare/" class="elementor-sub-item" tabindex="-1">Health &#038; Social Welfare</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10493"><a href="https://www.fidelitybank.ng/csr/education/" class="elementor-sub-item" tabindex="-1">Education</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10490"><a href="https://www.fidelitybank.ng/csr/youth-empowerment/" class="elementor-sub-item" tabindex="-1">Youth Empowerment</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10491"><a href="https://www.fidelitybank.ng/csr/environment/" class="elementor-sub-item" tabindex="-1">Environment</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-10487"><a href="https://www.fidelitybank.ng/csr/sustainability/" class="elementor-sub-item" tabindex="-1">Sustainability</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-12780"><a href="https://www.fidelitybank.ng/blog/" class="elementor-item" tabindex="-1">Media</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-34221"><a href="https://www.fidelitybank.ng/media-centre/" class="elementor-sub-item" tabindex="-1">Media Centre</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-14389"><a href="https://www.fidelitybank.ng/gallery/" class="elementor-sub-item" tabindex="-1">Gallery</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15146"><a href="https://www.fidelitybank.ng/magazine-publication/" class="elementor-sub-item" tabindex="-1">Magazine Publication</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-14393"><a href="https://www.fidelitybank.ng/blog/" class="elementor-sub-item" tabindex="-1">Blog</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-49073"><a href="https://www.fidelitybank.ng/help-support/" class="elementor-item" tabindex="-1">Helpdesk</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-49106"><a href="https://www.fidelitybank.ng/help-support/" class="elementor-sub-item" tabindex="-1">Help &#038; Support</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-17947"><a href="https://www.fidelitybank.ng/contact-us/" class="elementor-sub-item" tabindex="-1">True Serve</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-49120"><a href="https://www.fidelitybank.ng/feedback/" class="elementor-sub-item" tabindex="-1">Voice of Customer</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-14395"><a href="https://www.fidelitybank.ng/branch-locator/" class="elementor-sub-item" tabindex="-1">Branch/ATM Locator</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-46014"><a href="https://www.fidelitybank.ng/careers/" class="elementor-sub-item" tabindex="-1">Careers</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-17945"><a href="https://www.fidelitybank.ng/shareholder-enquiry/" class="elementor-sub-item" tabindex="-1">Shareholder Enquiry</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15779"><a href="https://www.fidelitybank.ng/information-security/" class="elementor-sub-item" tabindex="-1">Information Security</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16511"><a href="https://www.fidelitybank.ng/contact-us/whistle-blowing/" class="elementor-sub-item" tabindex="-1">Whistle Blowing</a></li>
</ul>
</li>
</ul>			</nav>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-16 elementor-inner-column elementor-element elementor-element-1809624d elementor-hidden-desktop elementor-hidden-tablet" data-id="1809624d" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-c2f2670 elementor-align-left elementor-tablet-align-right elementor-mobile-align-center elementor-hidden-desktop elementor-hidden-tablet elementor-widget elementor-widget-button" data-id="c2f2670" data-element_type="widget" data-widget_type="button.default">
				<div class="elementor-widget-container">
							<div class="elementor-button-wrapper">
					<a class="elementor-button elementor-button-link elementor-size-sm" href="#elementor-action%3Aaction%3Dpopup%3Aopen%26settings%3DeyJpZCI6IjM3NDEwIiwidG9nZ2xlIjpmYWxzZX0%3D">
						<span class="elementor-button-content-wrapper">
						<span class="elementor-button-icon">
				<svg xmlns="http://www.w3.org/2000/svg" width="13" height="14" viewBox="0 0 13 14" fill="none"><path d="M3.44431 6.64995V4.24997C3.44431 3.45433 3.76623 2.69128 4.33926 2.12867C4.91228 1.56607 5.68948 1.25 6.49986 1.25C7.31025 1.25 8.08744 1.56607 8.66046 2.12867C9.23349 2.69128 9.55542 3.45433 9.55542 4.24997V6.64995M2.22222 6.65009H10.7778C11.1019 6.65009 11.4128 6.77652 11.642 7.00156C11.8712 7.2266 12 7.53182 12 7.85008V12.05C12 12.2076 11.9684 12.3637 11.907 12.5093C11.8455 12.6548 11.7555 12.7871 11.642 12.8986C11.5285 13.01 11.3938 13.0984 11.2455 13.1587C11.0972 13.219 10.9383 13.25 10.7778 13.25H2.22222C2.06172 13.25 1.90278 13.219 1.7545 13.1587C1.60621 13.0984 1.47147 13.01 1.35798 12.8986C1.24449 12.7871 1.15446 12.6548 1.09304 12.5093C1.03161 12.3637 1 12.2076 1 12.05V7.85008C1 7.53182 1.12877 7.2266 1.35798 7.00156C1.58719 6.77652 1.89807 6.65009 2.22222 6.65009Z" stroke="white" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></svg>			</span>
									<span class="elementor-button-text">Login</span>
					</span>
					</a>
				</div>
						</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-16 elementor-inner-column elementor-element elementor-element-8dcfbc3" data-id="8dcfbc3" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-0365ce5 elementor-search-form--skin-full_screen elementor-widget elementor-widget-search-form" data-id="0365ce5" data-element_type="widget" data-settings="{&quot;skin&quot;:&quot;full_screen&quot;,&quot;_animation&quot;:&quot;none&quot;}" data-widget_type="search-form.default">
				<div class="elementor-widget-container">
					<search role="search">
			<form class="elementor-search-form" action="https://www.fidelitybank.ng" method="get">
												<div class="elementor-search-form__toggle" tabindex="0" role="button">
					<i aria-hidden="true" class="fas fa-search"></i>					<span class="elementor-screen-only">Search</span>
				</div>
								<div class="elementor-search-form__container">
					<label class="elementor-screen-only" for="elementor-search-form-0365ce5">Search</label>

					
					<input id="elementor-search-form-0365ce5" placeholder="Type and Press Enter" class="elementor-search-form__input" type="search" name="s" value="">
					
					
										<div class="dialog-lightbox-close-button dialog-close-button" role="button" tabindex="0">
						<i aria-hidden="true" class="eicon-close"></i>						<span class="elementor-screen-only">Close this search box.</span>
					</div>
									</div>
			</form>
		</search>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-16 elementor-inner-column elementor-element elementor-element-2f9f8dc1" data-id="2f9f8dc1" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-1b26ed3 elementor-widget elementor-widget-image" data-id="1b26ed3" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
														<a href="https://www.fidelitybank.ng">
							<img width="130" height="32" src="/wp-content/uploads/2020/07/Fidelity_Bank_Plc_Main_Logo.svg" class="attachment-full size-full wp-image-37562" alt="" />								</a>
													</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-inner-section elementor-element elementor-element-1cf8ad4 elementor-section-content-middle elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="1cf8ad4" data-element_type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;888295e&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-no">
					<div class="elementor-column elementor-col-100 elementor-inner-column elementor-element elementor-element-4660595" data-id="4660595" data-element_type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-abf0dde elementor-hidden-tablet elementor-hidden-phone elementor-widget elementor-widget-ekit-nav-menu" data-id="abf0dde" data-element_type="widget" data-widget_type="ekit-nav-menu.default">
				<div class="elementor-widget-container">
					<nav class="ekit-wid-con " 
			data-hamburger-icon="" 
			data-hamburger-icon-type="icon" 
			data-responsive-breakpoint="767">
			            <button class="elementskit-menu-hamburger elementskit-menu-toggler"  type="button" aria-label="hamburger-icon">
                                    <span class="elementskit-menu-hamburger-icon"></span><span class="elementskit-menu-hamburger-icon"></span><span class="elementskit-menu-hamburger-icon"></span>
                            </button>
            <style id="elementor-post-12809">.elementor-12809 .elementor-element.elementor-element-0c868bd .elementor-repeater-item-c5f1fe1.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-12809 .elementor-element.elementor-element-20a9ce4 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-12809 .elementor-element.elementor-element-20a9ce4 > .elementor-element-populated{margin:5px 0px 0px 16px;--e-column-margin-right:0px;--e-column-margin-left:16px;}.elementor-12809 .elementor-element.elementor-element-211130b > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-12809 .elementor-element.elementor-element-211130b .elementor-heading-title{color:#002082;font-size:12px;font-weight:bold;}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(6px/2);}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(6px/2);}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(6px/2);margin-left:calc(6px/2);}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-6px/2);margin-left:calc(-6px/2);}body.rtl .elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-6px/2);}body:not(.rtl) .elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-6px/2);}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-12809 .elementor-element.elementor-element-ff8b7f6{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-12809 .elementor-element.elementor-element-ff8b7f6 .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-12809 .elementor-element.elementor-element-6911e0b > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-12809 .elementor-element.elementor-element-6911e0b > .elementor-element-populated{margin:5px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-12809 .elementor-element.elementor-element-dc77cf5 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-12809 .elementor-element.elementor-element-dc77cf5 .elementor-heading-title{color:#002082;font-size:12px;font-weight:bold;}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(8px/2);}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(8px/2);}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(8px/2);margin-left:calc(8px/2);}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-8px/2);margin-left:calc(-8px/2);}body.rtl .elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-8px/2);}body:not(.rtl) .elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-8px/2);}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-12809 .elementor-element.elementor-element-d6a051c{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-item > .elementor-icon-list-text, .elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-12809 .elementor-element.elementor-element-d6a051c .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-12809 .elementor-element.elementor-element-1968668 > .elementor-widget-container{margin:0px 20px 0px 0px;}.elementor-12809 .elementor-element.elementor-element-0c868bd:not(.elementor-motion-effects-element-type-background), .elementor-12809 .elementor-element.elementor-element-0c868bd > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FAFAFA;}.elementor-12809 .elementor-element.elementor-element-0c868bd > .elementor-container{min-height:250px;}.elementor-12809 .elementor-element.elementor-element-0c868bd, .elementor-12809 .elementor-element.elementor-element-0c868bd > .elementor-background-overlay{border-radius:0px 0px 10px 10px;}.elementor-12809 .elementor-element.elementor-element-0c868bd{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:20px 0px 10px 0px;}.elementor-12809 .elementor-element.elementor-element-0c868bd > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(min-width:768px){.elementor-12809 .elementor-element.elementor-element-6911e0b{width:25%;}.elementor-12809 .elementor-element.elementor-element-6343d28{width:41.331%;}}</style><style id="elementor-post-16697">.elementor-16697 .elementor-element.elementor-element-a6d4640 .elementor-repeater-item-2fc9a32.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-16697 .elementor-element.elementor-element-9dd0791 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-16697 .elementor-element.elementor-element-9dd0791 > .elementor-element-populated{margin:5px 0px 0px 16px;--e-column-margin-right:0px;--e-column-margin-left:16px;}.elementor-16697 .elementor-element.elementor-element-2dd5df9 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-16697 .elementor-element.elementor-element-2dd5df9 .elementor-heading-title{color:#002082;font-size:12px;font-weight:bold;}.elementor-16697 .elementor-element.elementor-element-1cae507 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(8px/2);}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(8px/2);}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(8px/2);margin-left:calc(8px/2);}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-8px/2);margin-left:calc(-8px/2);}body.rtl .elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-8px/2);}body:not(.rtl) .elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-8px/2);}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-16697 .elementor-element.elementor-element-1cae507{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-16697 .elementor-element.elementor-element-1cae507 .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002596;}.elementor-16697 .elementor-element.elementor-element-23c1062 .elementor-repeater-item-3647440.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-16697 .elementor-element.elementor-element-0cc3607 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:0px;}.elementor-16697 .elementor-element.elementor-element-0cc3607 > .elementor-element-populated{padding:0px 0px 0px 0px;}.elementor-16697 .elementor-element.elementor-element-f655a22 > .elementor-widget-container{margin:0px 0px 10px 0px;padding:0px 0px 0px 0px;}.elementor-16697 .elementor-element.elementor-element-f655a22{text-align:left;}.elementor-16697 .elementor-element.elementor-element-f655a22 img{width:100%;}.elementor-16697 .elementor-element.elementor-element-294c3e8 > .elementor-widget-container{padding:0px 0px 0px 0px;}.elementor-16697 .elementor-element.elementor-element-294c3e8{text-align:left;}.elementor-16697 .elementor-element.elementor-element-294c3e8 img{width:100%;}.elementor-16697 .elementor-element.elementor-element-ae310a9 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:0px;}.elementor-16697 .elementor-element.elementor-element-ae310a9 > .elementor-element-populated{padding:0px 10px 0px 0px;}.elementor-16697 .elementor-element.elementor-element-23c1062{margin-top:5px;margin-bottom:10px;padding:0px 0px 0px 0px;}.elementor-16697 .elementor-element.elementor-element-8d58342 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-16697 .elementor-element.elementor-element-8d58342 > .elementor-element-populated{margin:5px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-16697 .elementor-element.elementor-element-cba0dc5 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-16697 .elementor-element.elementor-element-cba0dc5 .elementor-heading-title{color:#002082;font-size:12px;font-weight:bold;}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(8px/2);}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(8px/2);}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(8px/2);margin-left:calc(8px/2);}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-8px/2);margin-left:calc(-8px/2);}body.rtl .elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-8px/2);}body:not(.rtl) .elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-8px/2);}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-16697 .elementor-element.elementor-element-533d2d6{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-16697 .elementor-element.elementor-element-533d2d6 .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-16697 .elementor-element.elementor-element-51e2e44 > .elementor-widget-container{margin:0px 20px 0px 0px;}.elementor-16697 .elementor-element.elementor-element-a6d4640:not(.elementor-motion-effects-element-type-background), .elementor-16697 .elementor-element.elementor-element-a6d4640 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FAFAFA;}.elementor-16697 .elementor-element.elementor-element-a6d4640 > .elementor-container{min-height:250px;}.elementor-16697 .elementor-element.elementor-element-a6d4640, .elementor-16697 .elementor-element.elementor-element-a6d4640 > .elementor-background-overlay{border-radius:0px 0px 10px 10px;}.elementor-16697 .elementor-element.elementor-element-a6d4640{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:20px 0px 10px 0px;}.elementor-16697 .elementor-element.elementor-element-a6d4640 > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(min-width:768px){.elementor-16697 .elementor-element.elementor-element-0cc3607{width:50%;}.elementor-16697 .elementor-element.elementor-element-ae310a9{width:49.688%;}.elementor-16697 .elementor-element.elementor-element-8d58342{width:25%;}.elementor-16697 .elementor-element.elementor-element-58daf3b{width:41.331%;}}</style><style id="elementor-post-12899">.elementor-12899 .elementor-element.elementor-element-faf50ed .elementor-repeater-item-55e61ca.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-12899 .elementor-element.elementor-element-c0b3224 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-12899 .elementor-element.elementor-element-c0b3224 > .elementor-element-populated{margin:5px 0px 0px 16px;--e-column-margin-right:0px;--e-column-margin-left:16px;}.elementor-12899 .elementor-element.elementor-element-d871232 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-12899 .elementor-element.elementor-element-d871232 .elementor-heading-title{color:#002082;font-size:12px;font-weight:bold;}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(8px/2);}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(8px/2);}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(8px/2);margin-left:calc(8px/2);}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-8px/2);margin-left:calc(-8px/2);}body.rtl .elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-8px/2);}body:not(.rtl) .elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-8px/2);}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-12899 .elementor-element.elementor-element-390de3b{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-item > .elementor-icon-list-text, .elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-12899 .elementor-element.elementor-element-390de3b .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-12899 .elementor-element.elementor-element-85360fe > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-12899 .elementor-element.elementor-element-85360fe > .elementor-element-populated{margin:5px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-12899 .elementor-element.elementor-element-caf0c58 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-12899 .elementor-element.elementor-element-caf0c58 .elementor-heading-title{color:#002082;font-size:12px;font-weight:bold;}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(8px/2);}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(8px/2);}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(8px/2);margin-left:calc(8px/2);}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-8px/2);margin-left:calc(-8px/2);}body.rtl .elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-8px/2);}body:not(.rtl) .elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-8px/2);}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-12899 .elementor-element.elementor-element-3399a8a{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-item > .elementor-icon-list-text, .elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-12899 .elementor-element.elementor-element-3399a8a .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-12899 .elementor-element.elementor-element-47491e2 > .elementor-widget-container{margin:0px 20px 0px 0px;}.elementor-12899 .elementor-element.elementor-element-faf50ed:not(.elementor-motion-effects-element-type-background), .elementor-12899 .elementor-element.elementor-element-faf50ed > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FAFAFA;}.elementor-12899 .elementor-element.elementor-element-faf50ed > .elementor-container{min-height:250px;}.elementor-12899 .elementor-element.elementor-element-faf50ed, .elementor-12899 .elementor-element.elementor-element-faf50ed > .elementor-background-overlay{border-radius:0px 0px 10px 10px;}.elementor-12899 .elementor-element.elementor-element-faf50ed{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:20px 0px 10px 0px;}.elementor-12899 .elementor-element.elementor-element-faf50ed > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(min-width:768px){.elementor-12899 .elementor-element.elementor-element-85360fe{width:25%;}.elementor-12899 .elementor-element.elementor-element-ee41955{width:41.331%;}}</style><style id="elementor-post-12909">.elementor-12909 .elementor-element.elementor-element-4097ca0 .elementor-repeater-item-01591fd.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-12909 .elementor-element.elementor-element-fcd2b66 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-12909 .elementor-element.elementor-element-fcd2b66 > .elementor-element-populated{margin:5px 0px 0px 16px;--e-column-margin-right:0px;--e-column-margin-left:16px;}.elementor-12909 .elementor-element.elementor-element-c05383b > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-12909 .elementor-element.elementor-element-c05383b .elementor-heading-title{color:#002082;font-size:12px;font-weight:bold;}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(8px/2);}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(8px/2);}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(8px/2);margin-left:calc(8px/2);}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-8px/2);margin-left:calc(-8px/2);}body.rtl .elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-8px/2);}body:not(.rtl) .elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-8px/2);}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-12909 .elementor-element.elementor-element-0d9966e{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-item > .elementor-icon-list-text, .elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-12909 .elementor-element.elementor-element-0d9966e .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-12909 .elementor-element.elementor-element-3e5155c > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-12909 .elementor-element.elementor-element-3e5155c > .elementor-element-populated{margin:5px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-12909 .elementor-element.elementor-element-f2886e1 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-12909 .elementor-element.elementor-element-f2886e1 .elementor-heading-title{color:#002082;font-size:12px;font-weight:bold;}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(8px/2);}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(8px/2);}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(8px/2);margin-left:calc(8px/2);}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-8px/2);margin-left:calc(-8px/2);}body.rtl .elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-8px/2);}body:not(.rtl) .elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-8px/2);}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-12909 .elementor-element.elementor-element-8e179c0{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-item > .elementor-icon-list-text, .elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-12909 .elementor-element.elementor-element-8e179c0 .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-12909 .elementor-element.elementor-element-26383ad > .elementor-widget-container{margin:0px 20px 0px 0px;}.elementor-12909 .elementor-element.elementor-element-4097ca0:not(.elementor-motion-effects-element-type-background), .elementor-12909 .elementor-element.elementor-element-4097ca0 > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FAFAFA;}.elementor-12909 .elementor-element.elementor-element-4097ca0 > .elementor-container{min-height:250px;}.elementor-12909 .elementor-element.elementor-element-4097ca0, .elementor-12909 .elementor-element.elementor-element-4097ca0 > .elementor-background-overlay{border-radius:0px 0px 10px 10px;}.elementor-12909 .elementor-element.elementor-element-4097ca0{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:20px 0px 10px 0px;}.elementor-12909 .elementor-element.elementor-element-4097ca0 > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(min-width:768px){.elementor-12909 .elementor-element.elementor-element-3e5155c{width:25%;}.elementor-12909 .elementor-element.elementor-element-a8072dc{width:41.331%;}}</style><style id="elementor-post-14774">.elementor-14774 .elementor-element.elementor-element-53bbfca .elementor-repeater-item-aaccea7.jet-parallax-section__layout .jet-parallax-section__image{background-size:auto;}.elementor-14774 .elementor-element.elementor-element-e6599f2 > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-14774 .elementor-element.elementor-element-e6599f2 > .elementor-element-populated{margin:5px 0px 0px 16px;--e-column-margin-right:0px;--e-column-margin-left:16px;}.elementor-14774 .elementor-element.elementor-element-88420a1 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-14774 .elementor-element.elementor-element-88420a1 .elementor-heading-title{color:#C09600;font-size:12px;font-weight:bold;}.elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(6px/2);}.elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(6px/2);}.elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(6px/2);margin-left:calc(6px/2);}.elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-6px/2);margin-left:calc(-6px/2);}body.rtl .elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-6px/2);}body:not(.rtl) .elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-6px/2);}.elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-14774 .elementor-element.elementor-element-11b7eea{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-item > .elementor-icon-list-text, .elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-14774 .elementor-element.elementor-element-11b7eea .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-14774 .elementor-element.elementor-element-de6464f > .elementor-widget-wrap > .elementor-widget:not(.elementor-widget__width-auto):not(.elementor-widget__width-initial):not(:last-child):not(.elementor-absolute){margin-bottom:8px;}.elementor-14774 .elementor-element.elementor-element-de6464f > .elementor-element-populated{margin:5px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-14774 .elementor-element.elementor-element-3fb3d40 > .elementor-widget-container{margin:0px 0px 10px 0px;}.elementor-14774 .elementor-element.elementor-element-3fb3d40 .elementor-heading-title{color:#C09600;font-size:12px;font-weight:bold;}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(8px/2);}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(8px/2);}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(8px/2);margin-left:calc(8px/2);}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-8px/2);margin-left:calc(-8px/2);}body.rtl .elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-8px/2);}body:not(.rtl) .elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-8px/2);}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-icon i{transition:color 0.3s;}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-icon svg{transition:fill 0.3s;}.elementor-14774 .elementor-element.elementor-element-e2ac53f{--e-icon-list-icon-size:20px;--icon-vertical-offset:0px;}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-item > a{font-size:12px;font-weight:500;}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-text{color:#666666;transition:color 0.3s;}.elementor-14774 .elementor-element.elementor-element-e2ac53f .elementor-icon-list-item:hover .elementor-icon-list-text{color:#002082;}.elementor-14774 .elementor-element.elementor-element-8af2e2e > .elementor-element-populated{margin:0px 0px 0px 0px;--e-column-margin-right:0px;--e-column-margin-left:0px;}.elementor-14774 .elementor-element.elementor-element-a256cf1 > .elementor-widget-container{margin:0px 20px 0px 0px;padding:0px 0px 0px 0px;}.elementor-14774 .elementor-element.elementor-element-53bbfca:not(.elementor-motion-effects-element-type-background), .elementor-14774 .elementor-element.elementor-element-53bbfca > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:#FFFAEC;}.elementor-14774 .elementor-element.elementor-element-53bbfca > .elementor-container{min-height:250px;}.elementor-14774 .elementor-element.elementor-element-53bbfca, .elementor-14774 .elementor-element.elementor-element-53bbfca > .elementor-background-overlay{border-radius:0px 0px 10px 10px;}.elementor-14774 .elementor-element.elementor-element-53bbfca{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:20px 0px 10px 0px;}.elementor-14774 .elementor-element.elementor-element-53bbfca > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}@media(min-width:768px){.elementor-14774 .elementor-element.elementor-element-de6464f{width:25%;}.elementor-14774 .elementor-element.elementor-element-8af2e2e{width:41.331%;}}</style><div id="ekit-megamenu-home-bottom-menu" class="elementskit-menu-container elementskit-menu-offcanvas-elements elementskit-navbar-nav-default ekit-nav-menu-one-page-no ekit-nav-dropdown-hover"><ul id="menu-home-bottom-menu" class="elementskit-navbar-nav elementskit-menu-po-left submenu-click-on-icon"><li id="menu-item-10041" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-10041 nav-item elementskit-dropdown-has relative_position elementskit-dropdown-menu-default_width elementskit-megamenu-has elementskit-mobile-builder-content" data-vertical-menu=750px><a href="https://www.fidelitybank.ng/personal-banking/" class="ekit-menu-nav-link">Personal Banking<i aria-hidden="true" class="icon icon-none elementskit-submenu-indicator"></i></a><div class="elementskit-megamenu-panel">		<div data-elementor-type="wp-post" data-elementor-id="12809" class="elementor elementor-12809" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementskit_content">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-0c868bd elementor-section-height-min-height mega-menu-width elementor-section-items-top elementor-section-boxed elementor-section-height-default" data-id="0c868bd" data-element_type="section" id="Empocreat-mega-menu-personal" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;c5f1fe1&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-20a9ce4" data-id="20a9ce4" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-211130b elementor-widget elementor-widget-heading" data-id="211130b" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/personal-banking/">Personal Banking</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-ff8b7f6 elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="ff8b7f6" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/savings-account/">

											<span class="elementor-icon-list-text">Savings Account</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/current-account/">

											<span class="elementor-icon-list-text">Current Account</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/diaspora-banking/">

											<span class="elementor-icon-list-text">Diaspora Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/treasury-and-investment/">

											<span class="elementor-icon-list-text">Investment Services</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/personal-loans/">

											<span class="elementor-icon-list-text">Personal Loans</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/money-transfer/">

											<span class="elementor-icon-list-text">Money Transfer</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-6911e0b" data-id="6911e0b" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-dc77cf5 elementor-widget elementor-widget-heading" data-id="dc77cf5" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/help-support/">Self Services</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-d6a051c elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="d6a051c" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/branch-locator/">

											<span class="elementor-icon-list-text">Find a Branch or ATM</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/">

											<span class="elementor-icon-list-text">Loan Calculator</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://eserve.fidelitybank.ng/oap/">

											<span class="elementor-icon-list-text">Open an Account</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/contact-us/">

											<span class="elementor-icon-list-text">True Serve</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://wa.me/2349030000302?text=Hello%20IVY" target="_blank" rel="nofollow">

											<span class="elementor-icon-list-text">Chat with Ivy</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-6343d28" data-id="6343d28" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-1968668 elementor-widget elementor-widget-image" data-id="1968668" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img fetchpriority="high" width="300" height="240" src="/wp-content/uploads/2020/08/Fidelity-real-lifestyle-banking-1.jpg" class="attachment-full size-full wp-image-24737" alt="" />													</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div></li>
<li id="menu-item-16666" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16666 nav-item elementskit-dropdown-has relative_position elementskit-dropdown-menu-default_width elementskit-megamenu-has elementskit-mobile-builder-content" data-vertical-menu=750px><a href="https://www.fidelitybank.ng/digital-banking/" class="ekit-menu-nav-link">Digital Banking<i aria-hidden="true" class="icon icon-none elementskit-submenu-indicator"></i></a><div class="elementskit-megamenu-panel">		<div data-elementor-type="wp-post" data-elementor-id="16697" class="elementor elementor-16697" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementskit_content">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-a6d4640 elementor-section-height-min-height mega-menu-width elementor-section-items-top elementor-section-boxed elementor-section-height-default" data-id="a6d4640" data-element_type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;2fc9a32&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-9dd0791" data-id="9dd0791" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-2dd5df9 elementor-widget elementor-widget-heading" data-id="2dd5df9" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/digital-banking/">Digital Banking</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-1cae507 elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="1cae507" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/personal-e-banking/my-770/">

											<span class="elementor-icon-list-text">Instant Banking (*770#)</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/fidelity-card/">

											<span class="elementor-icon-list-text">Fidelity Cards</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/digital-banking/fidelity-collections/">

											<span class="elementor-icon-list-text">Fidelity Collections</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/digital-banking/online-banking/">

											<span class="elementor-icon-list-text">Online Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/personal-e-banking/online-banking-mobile-app/">

											<span class="elementor-icon-list-text">Online Banking Mobile App</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
				<section class="elementor-section elementor-inner-section elementor-element elementor-element-23c1062 elementor-section-full_width elementor-section-height-default elementor-section-height-default" data-id="23c1062" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;3647440&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-no">
					<div class="elementor-column elementor-col-50 elementor-inner-column elementor-element elementor-element-0cc3607" data-id="0cc3607" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-f655a22 elementor-widget elementor-widget-image" data-id="f655a22" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
														<a href="https://apps.apple.com/us/app/fidelity-online-banking/id1051038075" target="_blank">
							<img loading="lazy" width="540" height="160" src="/wp-content/uploads/2022/12/Apple_Store_Logo.svg" class="attachment-full size-full wp-image-41744" alt="" />								</a>
													</div>
				</div>
				<div class="elementor-element elementor-element-294c3e8 elementor-widget elementor-widget-image" data-id="294c3e8" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
														<a href="https://play.google.com/store/apps/details?id=com.interswitchng.www&#038;hl=en" target="_blank">
							<img loading="lazy" width="923" height="274" src="/wp-content/uploads/2022/12/Google_Play_Store.svg" class="attachment-full size-full wp-image-41743" alt="" />								</a>
													</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-inner-column elementor-element elementor-element-ae310a9" data-id="ae310a9" data-element_type="column">
			<div class="elementor-widget-wrap">
							</div>
		</div>
					</div>
		</section>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-8d58342" data-id="8d58342" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-cba0dc5 elementor-widget elementor-widget-heading" data-id="cba0dc5" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/help-support/">Self Services</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-533d2d6 elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="533d2d6" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/branch-locator/">

											<span class="elementor-icon-list-text">Find a Branch or ATM</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/">

											<span class="elementor-icon-list-text">Loan Calculator</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/open-account/">

											<span class="elementor-icon-list-text">Open an Account</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://eserve.fidelitybank.ng/nin_portal/" target="_blank" rel="nofollow">

											<span class="elementor-icon-list-text">NIN Portal</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://wa.me/2349030000302?text=Hello%20IVY" target="_blank" rel="nofollow">

											<span class="elementor-icon-list-text">Chat with Ivy</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-58daf3b" data-id="58daf3b" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-51e2e44 elementor-widget elementor-widget-image" data-id="51e2e44" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" width="300" height="240" src="/wp-content/uploads/2020/08/Digital-feature-images.jpg" class="attachment-full size-full wp-image-24736" alt="" />													</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div></li>
<li id="menu-item-10042" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-10042 nav-item elementskit-dropdown-has relative_position elementskit-dropdown-menu-default_width elementskit-megamenu-has elementskit-mobile-builder-content" data-vertical-menu=750px><a href="https://www.fidelitybank.ng/sme-banking/" class="ekit-menu-nav-link">SME Banking<i aria-hidden="true" class="icon icon-none elementskit-submenu-indicator"></i></a><div class="elementskit-megamenu-panel">		<div data-elementor-type="wp-post" data-elementor-id="12899" class="elementor elementor-12899" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementskit_content">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-faf50ed elementor-section-height-min-height mega-menu-width elementor-section-items-top elementor-section-boxed elementor-section-height-default" data-id="faf50ed" data-element_type="section" id="Empocreat-mega-menu-sme" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;55e61ca&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-c0b3224" data-id="c0b3224" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-d871232 elementor-widget elementor-widget-heading" data-id="d871232" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/sme-banking/">SME Banking</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-390de3b elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="390de3b" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/low-cost-current-account-offerings/">

											<span class="elementor-icon-list-text">Low Cost Current Accounts</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/sme-loans-and-advances/">

											<span class="elementor-icon-list-text">SME Loans & Advances</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/advisory-services/">

											<span class="elementor-icon-list-text">Business Advisory Services</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/sme-radio-forum/">

											<span class="elementor-icon-list-text">Fidelity SME Forum</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://digital.fidelitybank.ng/accountopening/#/">

											<span class="elementor-icon-list-text">Open Account Online</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-85360fe" data-id="85360fe" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-caf0c58 elementor-widget elementor-widget-heading" data-id="caf0c58" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/help-support/">Self Services</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-3399a8a elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="3399a8a" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/branch-locator/">

											<span class="elementor-icon-list-text">Find a Branch or ATM</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/">

											<span class="elementor-icon-list-text">Loan Calculator</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://digital.fidelitybank.ng/accountopening/#/" target="_blank">

											<span class="elementor-icon-list-text">Open an Account</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/contact-us/">

											<span class="elementor-icon-list-text">True Serve</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://wa.me/2349030000302?text=Hello%20IVY" target="_blank" rel="nofollow">

											<span class="elementor-icon-list-text">Chat with Ivy</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-ee41955" data-id="ee41955" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-47491e2 elementor-widget elementor-widget-image" data-id="47491e2" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" width="450" height="360" src="/wp-content/uploads/2020/10/Fidelity-nav2.jpg" class="attachment-full size-full wp-image-24726" alt="" srcset="/wp-content/uploads/2020/10/Fidelity-nav2.jpg 450w, /wp-content/uploads/2020/10/Fidelity-nav2-300x240.jpg 300w" sizes="(max-width: 450px) 100vw, 450px" />													</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div></li>
<li id="menu-item-10043" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-10043 nav-item elementskit-dropdown-has relative_position elementskit-dropdown-menu-default_width elementskit-megamenu-has elementskit-mobile-builder-content" data-vertical-menu=750px><a href="https://www.fidelitybank.ng/corporate-banking/" class="ekit-menu-nav-link">Corporate Banking<i aria-hidden="true" class="icon icon-none elementskit-submenu-indicator"></i></a><div class="elementskit-megamenu-panel">		<div data-elementor-type="wp-post" data-elementor-id="12909" class="elementor elementor-12909" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementskit_content">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-4097ca0 elementor-section-height-min-height mega-menu-width elementor-section-items-top elementor-section-boxed elementor-section-height-default" data-id="4097ca0" data-element_type="section" id="Empocreat-mega-menu-corporate" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;01591fd&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-fcd2b66" data-id="fcd2b66" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-c05383b elementor-widget elementor-widget-heading" data-id="c05383b" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/corporate-banking/">Corporate Banking</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-0d9966e elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="0d9966e" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/corporate-banking/exchange-rates/">

											<span class="elementor-icon-list-text">Exchange Rate</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/digital-banking/online-banking/corporate-onlinebanking/">

											<span class="elementor-icon-list-text">Corporate Online Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://conb.fidelitybank.ng/">

											<span class="elementor-icon-list-text">CONB Web Portal</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-3e5155c" data-id="3e5155c" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-f2886e1 elementor-widget elementor-widget-heading" data-id="f2886e1" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/help-support/">Self Services</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-8e179c0 elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="8e179c0" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/branch-locator/">

											<span class="elementor-icon-list-text">Find a Branch or ATM</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/">

											<span class="elementor-icon-list-text">Loan Calculator</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://digital.fidelitybank.ng/accountopening/#/">

											<span class="elementor-icon-list-text">Open an Account</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/contact-us/">

											<span class="elementor-icon-list-text">True Serve</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://wa.me/2349030000302?text=Hello%20IVY" target="_blank" rel="nofollow">

											<span class="elementor-icon-list-text">Chat with Ivy</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-a8072dc" data-id="a8072dc" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-26383ad elementor-widget elementor-widget-image" data-id="26383ad" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" width="450" height="360" src="/wp-content/uploads/2020/08/Fidelity-nav3.jpg" class="attachment-large size-large wp-image-14888" alt="Fidelity Bank Corporate Banking" srcset="/wp-content/uploads/2020/08/Fidelity-nav3.jpg 450w, /wp-content/uploads/2020/08/Fidelity-nav3-300x240.jpg 300w" sizes="(max-width: 450px) 100vw, 450px" />													</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div></li>
<li id="menu-item-10044" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-10044 nav-item elementskit-dropdown-has relative_position elementskit-dropdown-menu-default_width elementskit-megamenu-has elementskit-mobile-builder-content" data-vertical-menu=750px><a href="https://www.fidelitybank.ng/private-banking/" class="ekit-menu-nav-link">Private Banking<i aria-hidden="true" class="icon icon-none elementskit-submenu-indicator"></i></a><div class="elementskit-megamenu-panel">		<div data-elementor-type="wp-post" data-elementor-id="14774" class="elementor elementor-14774" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementskit_content">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-53bbfca elementor-section-height-min-height mega-menu-width elementor-section-items-top elementor-section-boxed elementor-section-height-default" data-id="53bbfca" data-element_type="section" id="Empocreat-mega-menu-private" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;aaccea7&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-e6599f2" data-id="e6599f2" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-88420a1 elementor-widget elementor-widget-heading" data-id="88420a1" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/private-banking/">Private Banking</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-11b7eea elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="11b7eea" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/private-banking/about-us-private-banking/">

											<span class="elementor-icon-list-text">About Private Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/private-banking/services-private-banking/">

											<span class="elementor-icon-list-text">Services</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/private-banking/testimonials-private-banking/">

											<span class="elementor-icon-list-text">Testimonials</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/private-banking/contact-us-private-banking/">

											<span class="elementor-icon-list-text">Contact Private Banking</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-de6464f" data-id="de6464f" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-3fb3d40 elementor-widget elementor-widget-heading" data-id="3fb3d40" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default"><a href="https://www.fidelitybank.ng/help-support/">Self Services</a></h2>		</div>
				</div>
				<div class="elementor-element elementor-element-e2ac53f elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="e2ac53f" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/branch-locator/">

											<span class="elementor-icon-list-text">Find a Branch or ATM</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/">

											<span class="elementor-icon-list-text">Loan Calculator</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/open-account/">

											<span class="elementor-icon-list-text">Open an Account</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/contact-us/">

											<span class="elementor-icon-list-text">True Serve</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://wa.me/2349030000302?text=Hello%20IVY" target="_blank" rel="nofollow">

											<span class="elementor-icon-list-text">Chat with Ivy</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-33 elementor-top-column elementor-element elementor-element-8af2e2e" data-id="8af2e2e" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-a256cf1 elementor-widget elementor-widget-image" data-id="a256cf1" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" width="525" height="420" src="/wp-content/uploads/2020/08/Nav-private-feature-images.jpg" class="attachment-full size-full wp-image-24735" alt="" srcset="/wp-content/uploads/2020/08/Nav-private-feature-images.jpg 525w, /wp-content/uploads/2020/08/Nav-private-feature-images-300x240.jpg 300w" sizes="(max-width: 525px) 100vw, 525px" />													</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div></li>
</ul><div class="elementskit-nav-identity-panel">
				<div class="elementskit-site-title">
					<a class="elementskit-nav-logo" href="https://www.fidelitybank.ng" target="_self" rel="">
						<img src="" title="" alt="" />
					</a> 
				</div><button class="elementskit-menu-close elementskit-menu-toggler" type="button">X</button></div></div>			
			<div class="elementskit-menu-overlay elementskit-menu-offcanvas-elements elementskit-menu-toggler ekit-nav-menu--overlay"></div>        </nav>
				</div>
				</div>
				<div class="elementor-element elementor-element-d8aa2c3 elementor-nav-menu--dropdown-none elementor-nav-menu__align-center elementor-hidden-desktop elementor-widget elementor-widget-nav-menu" data-id="d8aa2c3" data-element_type="widget" data-settings="{&quot;submenu_icon&quot;:{&quot;value&quot;:&quot;&lt;i class=\&quot;\&quot;&gt;&lt;\/i&gt;&quot;,&quot;library&quot;:&quot;&quot;},&quot;layout&quot;:&quot;horizontal&quot;}" data-widget_type="nav-menu.default">
				<div class="elementor-widget-container">
						<nav aria-label="Menu" class="elementor-nav-menu--main elementor-nav-menu__container elementor-nav-menu--layout-horizontal e--pointer-underline e--animation-fade">
				<ul id="menu-1-d8aa2c3" class="elementor-nav-menu"><li class="menu-item menu-item-type-post_type menu-item-object-page current-menu-ancestor current-menu-parent current_page_parent current_page_ancestor menu-item-has-children menu-item-14914"><a href="https://www.fidelitybank.ng/personal-banking/" class="elementor-item">Personal</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15785"><a href="https://www.fidelitybank.ng/personal-banking/savings-account/" class="elementor-sub-item">Savings Account</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15786"><a href="https://www.fidelitybank.ng/personal-banking/current-account/" class="elementor-sub-item">Current Account</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15787"><a href="https://www.fidelitybank.ng/personal-banking/diaspora-banking/" class="elementor-sub-item">Diaspora Banking</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page current-menu-item page_item page-item-15256 current_page_item menu-item-16864"><a href="https://www.fidelitybank.ng/treasury-and-investment/" aria-current="page" class="elementor-sub-item elementor-item-active">Investment Services</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15788"><a href="https://www.fidelitybank.ng/personal-banking/personal-loans/" class="elementor-sub-item">Personal Loans</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15789"><a href="https://www.fidelitybank.ng/personal-banking/money-transfer/" class="elementor-sub-item">Money Transfer</a></li>
	<li class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-14963"><a href="https://www.fidelitybank.ng/help-support/" class="elementor-sub-item">Self Services</a>
	<ul class="sub-menu elementor-nav-menu--dropdown">
		<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15076"><a href="https://www.fidelitybank.ng/branch-locator/" class="elementor-sub-item">Branch Locator</a></li>
		<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16677"><a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/" class="elementor-sub-item">Loan Calculator</a></li>
	</ul>
</li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-16669"><a href="https://www.fidelitybank.ng/digital-banking/" class="elementor-item">Digital</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15790"><a href="https://www.fidelitybank.ng/digital-banking/online-banking/" class="elementor-sub-item">Online Banking</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16670"><a href="https://www.fidelitybank.ng/personal-banking/personal-e-banking/online-banking-mobile-app/" class="elementor-sub-item">Online Banking App</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16672"><a href="https://www.fidelitybank.ng/personal-banking/personal-e-banking/my-770/" class="elementor-sub-item">Instant Banking *770#</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15103"><a href="https://www.fidelitybank.ng/fidelity-card/" class="elementor-sub-item">Fidelity Card</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15085"><a href="https://www.fidelitybank.ng/digital-banking/fidelity-collections/pay-gate/" class="elementor-sub-item">PayGate</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15088"><a href="https://www.fidelitybank.ng/digital-banking/fidelity-collections/fidelity-pos/" class="elementor-sub-item">Fidelity POS</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-16671"><a href="https://www.fidelitybank.ng/sme-banking/" class="elementor-item">SME</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15794"><a href="https://www.fidelitybank.ng/sme-banking/low-cost-current-account-offerings/" class="elementor-sub-item">Current Account</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15795"><a href="https://www.fidelitybank.ng/sme-banking/sme-loans-and-advances/" class="elementor-sub-item">SME Loans</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15797"><a href="https://www.fidelitybank.ng/sme-banking/sme-academy/" class="elementor-sub-item">Fidelity SME Academy</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16676"><a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/" class="elementor-sub-item">Loan Calculator</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-14913"><a href="https://www.fidelitybank.ng/corporate-banking/" class="elementor-item">Corporate</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-42269"><a href="https://www.fidelitybank.ng/corporate-banking/exchange-rates/" class="elementor-sub-item">Exchange Rates</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-14915"><a href="https://www.fidelitybank.ng/private-banking/" class="elementor-item">Private</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15114"><a href="https://www.fidelitybank.ng/private-banking/about-us-private-banking/" class="elementor-sub-item">About Us</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15113"><a href="https://www.fidelitybank.ng/private-banking/services-private-banking/" class="elementor-sub-item">Services</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15793"><a href="https://www.fidelitybank.ng/private-banking/testimonials-private-banking/" class="elementor-sub-item">Testimonials</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16862"><a href="https://www.fidelitybank.ng/private-banking/contact-us-private-banking/" class="elementor-sub-item">Contact Private Banking</a></li>
</ul>
</li>
</ul>			</nav>
						<nav class="elementor-nav-menu--dropdown elementor-nav-menu__container" aria-hidden="true">
				<ul id="menu-2-d8aa2c3" class="elementor-nav-menu"><li class="menu-item menu-item-type-post_type menu-item-object-page current-menu-ancestor current-menu-parent current_page_parent current_page_ancestor menu-item-has-children menu-item-14914"><a href="https://www.fidelitybank.ng/personal-banking/" class="elementor-item" tabindex="-1">Personal</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15785"><a href="https://www.fidelitybank.ng/personal-banking/savings-account/" class="elementor-sub-item" tabindex="-1">Savings Account</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15786"><a href="https://www.fidelitybank.ng/personal-banking/current-account/" class="elementor-sub-item" tabindex="-1">Current Account</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15787"><a href="https://www.fidelitybank.ng/personal-banking/diaspora-banking/" class="elementor-sub-item" tabindex="-1">Diaspora Banking</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page current-menu-item page_item page-item-15256 current_page_item menu-item-16864"><a href="https://www.fidelitybank.ng/treasury-and-investment/" aria-current="page" class="elementor-sub-item elementor-item-active" tabindex="-1">Investment Services</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15788"><a href="https://www.fidelitybank.ng/personal-banking/personal-loans/" class="elementor-sub-item" tabindex="-1">Personal Loans</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15789"><a href="https://www.fidelitybank.ng/personal-banking/money-transfer/" class="elementor-sub-item" tabindex="-1">Money Transfer</a></li>
	<li class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-14963"><a href="https://www.fidelitybank.ng/help-support/" class="elementor-sub-item" tabindex="-1">Self Services</a>
	<ul class="sub-menu elementor-nav-menu--dropdown">
		<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15076"><a href="https://www.fidelitybank.ng/branch-locator/" class="elementor-sub-item" tabindex="-1">Branch Locator</a></li>
		<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16677"><a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/" class="elementor-sub-item" tabindex="-1">Loan Calculator</a></li>
	</ul>
</li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-16669"><a href="https://www.fidelitybank.ng/digital-banking/" class="elementor-item" tabindex="-1">Digital</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15790"><a href="https://www.fidelitybank.ng/digital-banking/online-banking/" class="elementor-sub-item" tabindex="-1">Online Banking</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16670"><a href="https://www.fidelitybank.ng/personal-banking/personal-e-banking/online-banking-mobile-app/" class="elementor-sub-item" tabindex="-1">Online Banking App</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16672"><a href="https://www.fidelitybank.ng/personal-banking/personal-e-banking/my-770/" class="elementor-sub-item" tabindex="-1">Instant Banking *770#</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15103"><a href="https://www.fidelitybank.ng/fidelity-card/" class="elementor-sub-item" tabindex="-1">Fidelity Card</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15085"><a href="https://www.fidelitybank.ng/digital-banking/fidelity-collections/pay-gate/" class="elementor-sub-item" tabindex="-1">PayGate</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15088"><a href="https://www.fidelitybank.ng/digital-banking/fidelity-collections/fidelity-pos/" class="elementor-sub-item" tabindex="-1">Fidelity POS</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-16671"><a href="https://www.fidelitybank.ng/sme-banking/" class="elementor-item" tabindex="-1">SME</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15794"><a href="https://www.fidelitybank.ng/sme-banking/low-cost-current-account-offerings/" class="elementor-sub-item" tabindex="-1">Current Account</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15795"><a href="https://www.fidelitybank.ng/sme-banking/sme-loans-and-advances/" class="elementor-sub-item" tabindex="-1">SME Loans</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15797"><a href="https://www.fidelitybank.ng/sme-banking/sme-academy/" class="elementor-sub-item" tabindex="-1">Fidelity SME Academy</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16676"><a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/" class="elementor-sub-item" tabindex="-1">Loan Calculator</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-14913"><a href="https://www.fidelitybank.ng/corporate-banking/" class="elementor-item" tabindex="-1">Corporate</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-42269"><a href="https://www.fidelitybank.ng/corporate-banking/exchange-rates/" class="elementor-sub-item" tabindex="-1">Exchange Rates</a></li>
</ul>
</li>
<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-14915"><a href="https://www.fidelitybank.ng/private-banking/" class="elementor-item" tabindex="-1">Private</a>
<ul class="sub-menu elementor-nav-menu--dropdown">
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15114"><a href="https://www.fidelitybank.ng/private-banking/about-us-private-banking/" class="elementor-sub-item" tabindex="-1">About Us</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15113"><a href="https://www.fidelitybank.ng/private-banking/services-private-banking/" class="elementor-sub-item" tabindex="-1">Services</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15793"><a href="https://www.fidelitybank.ng/private-banking/testimonials-private-banking/" class="elementor-sub-item" tabindex="-1">Testimonials</a></li>
	<li class="menu-item menu-item-type-post_type menu-item-object-page menu-item-16862"><a href="https://www.fidelitybank.ng/private-banking/contact-us-private-banking/" class="elementor-sub-item" tabindex="-1">Contact Private Banking</a></li>
</ul>
</li>
</ul>			</nav>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
					</div>
		</div>
					</div>
		</header>
				</div>
		
<main id="content" class="site-main post-15256 page type-page status-publish hentry">

			<div class="page-header">
			<h1 class="entry-title">Treasury and Investment</h1>		</div>
	
	<div class="page-content">
				<div data-elementor-type="wp-page" data-elementor-id="15256" class="elementor elementor-15256" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="page">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-6428c5e elementor-section-stretched elementor-section-height-min-height elementor-section-boxed elementor-section-height-default elementor-section-items-middle" data-id="6428c5e" data-element_type="section" data-settings="{&quot;stretch_section&quot;:&quot;section-stretched&quot;,&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;a2237fc&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
							<div class="elementor-background-overlay"></div>
							<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-95c7d5e" data-id="95c7d5e" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-029051d elementor-widget elementor-widget-elementskit-heading" data-id="029051d" data-element_type="widget" data-widget_type="elementskit-heading.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" ><div class="ekit-heading elementskit-section-title-wraper text_left   ekit_heading_tablet-   ekit_heading_mobile-"><h2 class="ekit-heading--title elementskit-section-title ">Treasury &amp; Investment</h2>				<div class='ekit-heading__description'>
					<p>The expertise of our market specialists provide our clients (personal and corporate) with high quality, quick and best execution services on treasury products.</p>
				</div>
			</div></div>		</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-57f66cc elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="57f66cc" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;4aef5c2&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-184c206" data-id="184c206" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-1b9e76c elementor-align-left elementor-widget elementor-widget-breadcrumbs" data-id="1b9e76c" data-element_type="widget" data-widget_type="breadcrumbs.default">
				<div class="elementor-widget-container">
			<p id="breadcrumbs"><span><span><a href="https://fidelitybankng.azurewebsites.net/">Home</a></span> / <span class="breadcrumb_last" aria-current="page"><strong>Treasury and Investment</strong></span></span></p>		</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-3aeea87 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="3aeea87" data-element_type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;animation&quot;:&quot;none&quot;,&quot;animation_delay&quot;:100,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;ca39fb0&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-16 elementor-top-column elementor-element elementor-element-003d531" data-id="003d531" data-element_type="column">
			<div class="elementor-widget-wrap">
							</div>
		</div>
				<div class="elementor-column elementor-col-66 elementor-top-column elementor-element elementor-element-8bf885f" data-id="8bf885f" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-909d494 elementor-widget elementor-widget-elementskit-heading" data-id="909d494" data-element_type="widget" data-widget_type="elementskit-heading.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" ><div class="ekit-heading elementskit-section-title-wraper text_center   ekit_heading_tablet-   ekit_heading_mobile-"><h5 class="elementskit-section-subtitle  ">
						treasury &amp; investment
					</h5><h2 class="ekit-heading--title elementskit-section-title ">We Provide The Best Advisory Services<br> With Competitive Market Rates</h2></div></div>		</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-16 elementor-top-column elementor-element elementor-element-05c8bfe" data-id="05c8bfe" data-element_type="column">
			<div class="elementor-widget-wrap">
							</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-381d20d elementor-section-stretched elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="381d20d" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;8c48ff1&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}],&quot;stretch_section&quot;:&quot;section-stretched&quot;,&quot;background_background&quot;:&quot;classic&quot;}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-c491749" data-id="c491749" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-17b0808 elementor-widget elementor-widget-image" data-id="17b0808" data-element_type="widget" data-settings="{&quot;motion_fx_motion_fx_scrolling&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_effect&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_speed&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:1.4,&quot;sizes&quot;:[]},&quot;motion_fx_translateY_affectedRange&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:{&quot;start&quot;:0,&quot;end&quot;:100}},&quot;motion_fx_devices&quot;:[&quot;desktop&quot;,&quot;tablet&quot;,&quot;mobile&quot;]}" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" decoding="async" width="600" height="750" src="/wp-content/uploads/2020/08/fx1.jpg" class="attachment-full size-full wp-image-15266" alt="fidelity bank treasury and investment" srcset="/wp-content/uploads/2020/08/fx1.jpg 600w, /wp-content/uploads/2020/08/fx1-240x300.jpg 240w" sizes="(max-width: 600px) 100vw, 600px" />													</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-ca5c81b" data-id="ca5c81b" data-element_type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-bd5c952 elementor-widget elementor-widget-elementskit-heading" data-id="bd5c952" data-element_type="widget" data-widget_type="elementskit-heading.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" ><div class="ekit-heading elementskit-section-title-wraper text_left   ekit_heading_tablet-   ekit_heading_mobile-"><h5 class="elementskit-section-subtitle  ">
						PRODUCTS
					</h5><h2 class="ekit-heading--title elementskit-section-title ">Foreign <br>  Exchange &amp; Derivatives</h2><div class="ekit_heading_separetor_wraper ekit_heading_elementskit-border-divider elementskit-style-long"><div class="elementskit-border-divider elementskit-style-long"></div></div></div></div>		</div>
				</div>
				<div class="elementor-element elementor-element-ef77a90 elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="ef77a90" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Currency Trading (spot and forwards) in all major and emerging market currencies – GBP/USD, EUR/USD, EUR/GBP, CAD/USD and other currency pairs.</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Hedging instruments against foreign exchange risks:</span>
									</li>
						</ul>
				</div>
				</div>
				<div class="elementor-element elementor-element-93f6765 elementor-widget elementor-widget-text-editor" data-id="93f6765" data-element_type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
							<ul><li>Non &#8211; Deliverable forwards.</li><li>Deliverable forwards.</li><li>Cross Currency Swap.</li></ul>						</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-81b16de elementor-reverse-mobile elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="81b16de" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;4703f02&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-ed11565" data-id="ed11565" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-d308c78 elementor-widget elementor-widget-elementskit-heading" data-id="d308c78" data-element_type="widget" data-widget_type="elementskit-heading.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" ><div class="ekit-heading elementskit-section-title-wraper text_left   ekit_heading_tablet-   ekit_heading_mobile-"><h5 class="elementskit-section-subtitle  ">
						PRODUCTS
					</h5><h2 class="ekit-heading--title elementskit-section-title ">Fixed Income <br> Securities</h2><div class="ekit_heading_separetor_wraper ekit_heading_elementskit-border-divider elementskit-style-long"><div class="elementskit-border-divider elementskit-style-long"></div></div></div></div>		</div>
				</div>
				<div class="elementor-element elementor-element-9d4394d elementor-widget elementor-widget-text-editor" data-id="9d4394d" data-element_type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
							<p>Our treasury experts facilitate the execution of fixed income securities at the best price and execution.<br />We help you channel your excess cash into a range of Fixed Income products and other products that can be tailored to customers’ needs.</p>						</div>
				</div>
				<div class="elementor-element elementor-element-9ff2b85 elementor-widget elementor-widget-eael-adv-accordion" data-id="9ff2b85" data-element_type="widget" data-widget_type="eael-adv-accordion.default">
				<div class="elementor-widget-container">
			        <div class="eael-adv-accordion" id="eael-adv-accordion-9ff2b85" data-scroll-on-click="no" data-scroll-speed="300" data-accordion-id="9ff2b85" data-accordion-type="accordion" data-toogle-speed="300">
    <div class="eael-accordion-list">
                <div id="offering" class="elementor-tab-title eael-accordion-header" tabindex="0" data-tab="1" aria-controls="elementor-tab-content-1671"><span class="eael-accordion-tab-title">Offering</span><i aria-hidden="true" class="fa-toggle fas fa-plus"></i></div><div id="elementor-tab-content-1671" class="eael-accordion-content clearfix" data-tab="1" aria-labelledby="offering"><style id="elementor-post-16717">.elementor-16717 .elementor-element.elementor-element-47bd02f > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(7px/2);}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(7px/2);}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(7px/2);margin-left:calc(7px/2);}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-7px/2);margin-left:calc(-7px/2);}body.rtl .elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-7px/2);}body:not(.rtl) .elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-7px/2);}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16717 .elementor-element.elementor-element-47bd02f{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon{padding-right:1px;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:16px;letter-spacing:-0.8px;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}</style><style>.elementor-16717 .elementor-element.elementor-element-47bd02f > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(7px/2);}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(7px/2);}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(7px/2);margin-left:calc(7px/2);}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-7px/2);margin-left:calc(-7px/2);}body.rtl .elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-7px/2);}body:not(.rtl) .elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-7px/2);}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16717 .elementor-element.elementor-element-47bd02f{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon{padding-right:1px;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:16px;letter-spacing:-0.8px;}.elementor-16717 .elementor-element.elementor-element-47bd02f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}</style>		<div data-elementor-type="section" data-elementor-id="16717" class="elementor elementor-16717" data-elementor-post-type="elementor_library">
					<section class="elementor-section elementor-top-section elementor-element elementor-element-7157f99 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="7157f99" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-96a9fc7" data-id="96a9fc7" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-47bd02f elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="47bd02f" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">FGN Bonds</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Subnational Bonds</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Municipal Bonds</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Corporate bonds</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Supranational Bonds</span>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div>
                </div><div class="eael-accordion-list">
                <div id="features" class="elementor-tab-title eael-accordion-header" tabindex="0" data-tab="2" aria-controls="elementor-tab-content-1672"><span class="eael-accordion-tab-title">Features</span><i aria-hidden="true" class="fa-toggle fas fa-plus"></i></div><div id="elementor-tab-content-1672" class="eael-accordion-content clearfix" data-tab="2" aria-labelledby="features"><style id="elementor-post-16723">.elementor-16723 .elementor-element.elementor-element-47bd02f > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(7px/2);}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(7px/2);}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(7px/2);margin-left:calc(7px/2);}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-7px/2);margin-left:calc(-7px/2);}body.rtl .elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-7px/2);}body:not(.rtl) .elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-7px/2);}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16723 .elementor-element.elementor-element-47bd02f{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon{padding-right:1px;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:16px;letter-spacing:-0.8px;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}</style><style>.elementor-16723 .elementor-element.elementor-element-47bd02f > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(7px/2);}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(7px/2);}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(7px/2);margin-left:calc(7px/2);}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-7px/2);margin-left:calc(-7px/2);}body.rtl .elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-7px/2);}body:not(.rtl) .elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-7px/2);}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16723 .elementor-element.elementor-element-47bd02f{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-icon{padding-right:1px;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:16px;letter-spacing:-0.8px;}.elementor-16723 .elementor-element.elementor-element-47bd02f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}</style>		<div data-elementor-type="page" data-elementor-id="16723" class="elementor elementor-16723" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementor_library">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-7157f99 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="7157f99" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-96a9fc7" data-id="96a9fc7" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-47bd02f elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="47bd02f" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">FGN bonds have fixed interest rates, which are paid semi-annually.</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Investment tenor brackets could range from 3,5,7 years and up to 30 years</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">FGN bonds are backed by the ‘full faith and credit’ of the Federal        Government, and as such it is classified as a risk free debt instrument.</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Interest earned is tax free.</span>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div>
                </div></div>		</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-949c159" data-id="949c159" data-element_type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-6177dd8 elementor-widget elementor-widget-image" data-id="6177dd8" data-element_type="widget" data-settings="{&quot;motion_fx_motion_fx_scrolling&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_effect&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_speed&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:1.2,&quot;sizes&quot;:[]},&quot;motion_fx_translateY_affectedRange&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:{&quot;start&quot;:0,&quot;end&quot;:100}},&quot;motion_fx_devices&quot;:[&quot;desktop&quot;,&quot;tablet&quot;,&quot;mobile&quot;]}" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" decoding="async" width="600" height="750" src="/wp-content/uploads/2020/08/corporate-banking-bond.jpg" class="attachment-full size-full wp-image-15771" alt="" srcset="/wp-content/uploads/2020/08/corporate-banking-bond.jpg 600w, /wp-content/uploads/2020/08/corporate-banking-bond-240x300.jpg 240w" sizes="(max-width: 600px) 100vw, 600px" />													</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-6e81ff1 elementor-section-stretched elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="6e81ff1" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;ad18c62&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}],&quot;stretch_section&quot;:&quot;section-stretched&quot;,&quot;background_background&quot;:&quot;classic&quot;}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-cbf1ddd" data-id="cbf1ddd" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-c6267dd elementor-widget elementor-widget-image" data-id="c6267dd" data-element_type="widget" data-settings="{&quot;motion_fx_motion_fx_scrolling&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_effect&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_speed&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:1.1,&quot;sizes&quot;:[]},&quot;motion_fx_translateY_affectedRange&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:{&quot;start&quot;:0,&quot;end&quot;:100}},&quot;motion_fx_devices&quot;:[&quot;desktop&quot;,&quot;tablet&quot;,&quot;mobile&quot;]}" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" decoding="async" width="600" height="750" src="/wp-content/uploads/2020/08/fx4.jpg" class="attachment-full size-full wp-image-15269" alt="fidelity bank treasury and investment" srcset="/wp-content/uploads/2020/08/fx4.jpg 600w, /wp-content/uploads/2020/08/fx4-240x300.jpg 240w" sizes="(max-width: 600px) 100vw, 600px" />													</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-1696e31" data-id="1696e31" data-element_type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-2bff2d0 elementor-widget elementor-widget-elementskit-heading" data-id="2bff2d0" data-element_type="widget" data-widget_type="elementskit-heading.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" ><div class="ekit-heading elementskit-section-title-wraper text_left   ekit_heading_tablet-   ekit_heading_mobile-"><h5 class="elementskit-section-subtitle  ">
						PRODUCTS
					</h5><h2 class="ekit-heading--title elementskit-section-title ">Nigerian <br> Treasury Bills</h2><div class="ekit_heading_separetor_wraper ekit_heading_elementskit-border-divider elementskit-style-long"><div class="elementskit-border-divider elementskit-style-long"></div></div></div></div>		</div>
				</div>
				<div class="elementor-element elementor-element-9bd5c15 elementor-widget elementor-widget-text-editor" data-id="9bd5c15" data-element_type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
							<p>Our vast treasury professionals facilitate the execution of Nigerian Treasury Bills at the best price and execution.</p>						</div>
				</div>
				<div class="elementor-element elementor-element-56b1b28 elementor-widget elementor-widget-eael-adv-accordion" data-id="56b1b28" data-element_type="widget" data-widget_type="eael-adv-accordion.default">
				<div class="elementor-widget-container">
			        <div class="eael-adv-accordion" id="eael-adv-accordion-56b1b28" data-scroll-on-click="no" data-scroll-speed="300" data-accordion-id="56b1b28" data-accordion-type="accordion" data-toogle-speed="300">
    <div class="eael-accordion-list">
                <div id="features" class="elementor-tab-title eael-accordion-header" tabindex="0" data-tab="1" aria-controls="elementor-tab-content-9091"><span class="eael-accordion-tab-title">Features</span><i aria-hidden="true" class="fa-toggle fas fa-plus"></i></div><div id="elementor-tab-content-9091" class="eael-accordion-content clearfix" data-tab="1" aria-labelledby="features"><style id="elementor-post-16732">.elementor-16732 .elementor-element.elementor-element-3deea0f > .elementor-widget-container{padding:0px 0px 0px 0px;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(4px/2);}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(4px/2);}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(4px/2);margin-left:calc(4px/2);}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-4px/2);margin-left:calc(-4px/2);}body.rtl .elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-4px/2);}body:not(.rtl) .elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-4px/2);}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16732 .elementor-element.elementor-element-3deea0f{--e-icon-list-icon-size:16px;--e-icon-list-icon-align:left;--e-icon-list-icon-margin:0 calc(var(--e-icon-list-icon-size, 1em) * 0.25) 0 0;--icon-vertical-offset:0px;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon{padding-right:1px;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:14px;letter-spacing:-0.8px;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}</style><style>.elementor-16732 .elementor-element.elementor-element-3deea0f > .elementor-widget-container{padding:0px 0px 0px 0px;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(4px/2);}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(4px/2);}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(4px/2);margin-left:calc(4px/2);}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-4px/2);margin-left:calc(-4px/2);}body.rtl .elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-4px/2);}body:not(.rtl) .elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-4px/2);}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16732 .elementor-element.elementor-element-3deea0f{--e-icon-list-icon-size:16px;--e-icon-list-icon-align:left;--e-icon-list-icon-margin:0 calc(var(--e-icon-list-icon-size, 1em) * 0.25) 0 0;--icon-vertical-offset:0px;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon{padding-right:1px;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:14px;letter-spacing:-0.8px;}.elementor-16732 .elementor-element.elementor-element-3deea0f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}</style>		<div data-elementor-type="section" data-elementor-id="16732" class="elementor elementor-16732" data-elementor-post-type="elementor_library">
					<section class="elementor-section elementor-top-section elementor-element elementor-element-4369bc3 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="4369bc3" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-9e347b3" data-id="9e347b3" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-3deea0f elementor-align-left elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="3deea0f" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Primary auction conducted bi-weekly for the 91 days, 182days and 364 days’ tenor.</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">The Nigerian treasury bills is backed by the ‘full faith and credit’ of the Federal Government, and as such it is classified as a risk free debt instrument</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Bills are sold at a discount. Hence Interest received upfront.</span>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div>
                </div></div>		</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-c14ece9 elementor-section-content-middle elementor-section-stretched elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="c14ece9" data-element_type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;f674c2d&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}],&quot;stretch_section&quot;:&quot;section-stretched&quot;}">
							<div class="elementor-background-overlay"></div>
							<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-b6c43cd" data-id="b6c43cd" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-8b9f75f elementor-widget elementor-widget-elementskit-heading" data-id="8b9f75f" data-element_type="widget" data-widget_type="elementskit-heading.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" ><div class="ekit-heading elementskit-section-title-wraper text_center   ekit_heading_tablet-   ekit_heading_mobile-"><h2 class="ekit-heading--title elementskit-section-title ">Enjoy guaranteed yield on your investments</h2>				<div class='ekit-heading__description'>
					<p>We are available to help you with any of your treasury and advisory needs. Drop us a line.</p>
				</div>
			</div></div>		</div>
				</div>
				<div class="elementor-element elementor-element-28c7271 button-transition elementor-align-center elementor-tablet-align-center elementor-widget elementor-widget-button" data-id="28c7271" data-element_type="widget" data-widget_type="button.default">
				<div class="elementor-widget-container">
							<div class="elementor-button-wrapper">
					<a class="elementor-button elementor-button-link elementor-size-sm" href="https://www.fidelitybank.ng/contact-us/">
						<span class="elementor-button-content-wrapper">
						<span class="elementor-button-icon">
				<i aria-hidden="true" class="fas fa-arrow-right"></i>			</span>
									<span class="elementor-button-text">GET IN TOUCH</span>
					</span>
					</a>
				</div>
						</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-a1804a7 elementor-reverse-mobile elementor-section-stretched elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="a1804a7" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;1d7acab&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}],&quot;stretch_section&quot;:&quot;section-stretched&quot;,&quot;background_background&quot;:&quot;classic&quot;}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-800da90" data-id="800da90" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-fe602b2 elementor-widget elementor-widget-elementskit-heading" data-id="fe602b2" data-element_type="widget" data-widget_type="elementskit-heading.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" ><div class="ekit-heading elementskit-section-title-wraper text_left   ekit_heading_tablet-   ekit_heading_mobile-"><h5 class="elementskit-section-subtitle  ">
						PRODUCTS
					</h5><h2 class="ekit-heading--title elementskit-section-title ">Eurobonds</h2><div class="ekit_heading_separetor_wraper ekit_heading_elementskit-border-divider elementskit-style-long"><div class="elementskit-border-divider elementskit-style-long"></div></div></div></div>		</div>
				</div>
				<div class="elementor-element elementor-element-25e1544 elementor-widget elementor-widget-text-editor" data-id="25e1544" data-element_type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
							<p>We facilitate the execution of Eurobonds for our clients in the secondary market on best price and execution.</p>						</div>
				</div>
				<div class="elementor-element elementor-element-a2aa4bb elementor-widget elementor-widget-eael-adv-accordion" data-id="a2aa4bb" data-element_type="widget" data-widget_type="eael-adv-accordion.default">
				<div class="elementor-widget-container">
			        <div class="eael-adv-accordion" id="eael-adv-accordion-a2aa4bb" data-scroll-on-click="no" data-scroll-speed="300" data-accordion-id="a2aa4bb" data-accordion-type="accordion" data-toogle-speed="300">
    <div class="eael-accordion-list">
                <div id="features" class="elementor-tab-title eael-accordion-header" tabindex="0" data-tab="1" aria-controls="elementor-tab-content-1701"><span class="eael-accordion-tab-title">Features</span><i aria-hidden="true" class="fa-toggle fas fa-plus"></i></div><div id="elementor-tab-content-1701" class="eael-accordion-content clearfix" data-tab="1" aria-labelledby="features"><style id="elementor-post-16737">.elementor-16737 .elementor-element.elementor-element-3deea0f > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(7px/2);}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(7px/2);}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(7px/2);margin-left:calc(7px/2);}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-7px/2);margin-left:calc(-7px/2);}body.rtl .elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-7px/2);}body:not(.rtl) .elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-7px/2);}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16737 .elementor-element.elementor-element-3deea0f{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon{padding-right:1px;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:16px;letter-spacing:-0.8px;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}</style><style>.elementor-16737 .elementor-element.elementor-element-3deea0f > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(7px/2);}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(7px/2);}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(7px/2);margin-left:calc(7px/2);}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-7px/2);margin-left:calc(-7px/2);}body.rtl .elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-7px/2);}body:not(.rtl) .elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-7px/2);}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16737 .elementor-element.elementor-element-3deea0f{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon{padding-right:1px;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:16px;letter-spacing:-0.8px;}.elementor-16737 .elementor-element.elementor-element-3deea0f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}</style>		<div data-elementor-type="page" data-elementor-id="16737" class="elementor elementor-16737" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementor_library">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-4369bc3 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="4369bc3" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-9e347b3" data-id="9e347b3" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-3deea0f elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="3deea0f" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Interests are paid at intervals usually semi-annually.</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Investment is done in Foreign Currency funded through domiciliary inflows.</span>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div>
                </div></div>		</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-8704545" data-id="8704545" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-65aea84 elementor-widget elementor-widget-image" data-id="65aea84" data-element_type="widget" data-settings="{&quot;motion_fx_motion_fx_scrolling&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_effect&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_speed&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:1.7,&quot;sizes&quot;:[]},&quot;motion_fx_translateY_affectedRange&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:{&quot;start&quot;:0,&quot;end&quot;:100}},&quot;motion_fx_devices&quot;:[&quot;desktop&quot;,&quot;tablet&quot;,&quot;mobile&quot;]}" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" decoding="async" width="600" height="750" src="/wp-content/uploads/2020/08/fx3.jpg" class="attachment-full size-full wp-image-15268" alt="fidelity bank treasury and investment" srcset="/wp-content/uploads/2020/08/fx3.jpg 600w, /wp-content/uploads/2020/08/fx3-240x300.jpg 240w" sizes="(max-width: 600px) 100vw, 600px" />													</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-289f43c elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="289f43c" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;432dbfd&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-ad1e393" data-id="ad1e393" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-7c0b768 elementor-widget elementor-widget-image" data-id="7c0b768" data-element_type="widget" data-settings="{&quot;motion_fx_motion_fx_scrolling&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_effect&quot;:&quot;yes&quot;,&quot;motion_fx_translateY_speed&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:1.4,&quot;sizes&quot;:[]},&quot;motion_fx_translateY_affectedRange&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:{&quot;start&quot;:0,&quot;end&quot;:100}},&quot;motion_fx_devices&quot;:[&quot;desktop&quot;,&quot;tablet&quot;,&quot;mobile&quot;]}" data-widget_type="image.default">
				<div class="elementor-widget-container">
													<img loading="lazy" decoding="async" width="600" height="750" src="/wp-content/uploads/2020/08/fx5.jpg" class="attachment-full size-full wp-image-15270" alt="fidelity bank treasury and investment" srcset="/wp-content/uploads/2020/08/fx5.jpg 600w, /wp-content/uploads/2020/08/fx5-240x300.jpg 240w" sizes="(max-width: 600px) 100vw, 600px" />													</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-cae71b9" data-id="cae71b9" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-915244a elementor-widget elementor-widget-elementskit-heading" data-id="915244a" data-element_type="widget" data-widget_type="elementskit-heading.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" ><div class="ekit-heading elementskit-section-title-wraper text_left   ekit_heading_tablet-   ekit_heading_mobile-"><h5 class="elementskit-section-subtitle  ">
						PRODUCTS
					</h5><h2 class="ekit-heading--title elementskit-section-title ">Money <br> Market Deposits</h2><div class="ekit_heading_separetor_wraper ekit_heading_elementskit-border-divider elementskit-style-long"><div class="elementskit-border-divider elementskit-style-long"></div></div></div></div>		</div>
				</div>
				<div class="elementor-element elementor-element-91fece3 elementor-widget elementor-widget-text-editor" data-id="91fece3" data-element_type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
							<p>We help you channel your excess cash into a range of Money Market Products such as:</p>						</div>
				</div>
				<div class="elementor-element elementor-element-5f6c27e elementor-align-left elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="5f6c27e" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Savings Account Deposit.</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Current Account Deposit.</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Call Deposit</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Savings Account Deposit.</span>
									</li>
						</ul>
				</div>
				</div>
				<div class="elementor-element elementor-element-f7a56ac elementor-widget elementor-widget-text-editor" data-id="f7a56ac" data-element_type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
							<p>Depositors will receive the best advisory services on how to invest their funds. We offer competitive rates on both foreign and local currency deposits.</p>						</div>
				</div>
				<div class="elementor-element elementor-element-2f10dce elementor-widget elementor-widget-eael-adv-accordion" data-id="2f10dce" data-element_type="widget" data-widget_type="eael-adv-accordion.default">
				<div class="elementor-widget-container">
			        <div class="eael-adv-accordion" id="eael-adv-accordion-2f10dce" data-scroll-on-click="no" data-scroll-speed="300" data-accordion-id="2f10dce" data-accordion-type="accordion" data-toogle-speed="300">
    <div class="eael-accordion-list">
                <div id="features" class="elementor-tab-title eael-accordion-header" tabindex="0" data-tab="1" aria-controls="elementor-tab-content-4931"><span class="eael-accordion-tab-title">Features</span><i aria-hidden="true" class="fa-toggle fas fa-plus"></i></div><div id="elementor-tab-content-4931" class="eael-accordion-content clearfix" data-tab="1" aria-labelledby="features"><style id="elementor-post-16741">.elementor-16741 .elementor-element.elementor-element-3deea0f > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(7px/2);}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(7px/2);}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(7px/2);margin-left:calc(7px/2);}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-7px/2);margin-left:calc(-7px/2);}body.rtl .elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-7px/2);}body:not(.rtl) .elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-7px/2);}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16741 .elementor-element.elementor-element-3deea0f{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon{padding-right:1px;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:16px;letter-spacing:-0.8px;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}</style><style>.elementor-16741 .elementor-element.elementor-element-3deea0f > .elementor-widget-container{margin:0px 0px 0px 0px;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:last-child){padding-bottom:calc(7px/2);}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items:not(.elementor-inline-items) .elementor-icon-list-item:not(:first-child){margin-top:calc(7px/2);}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item{margin-right:calc(7px/2);margin-left:calc(7px/2);}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items{margin-right:calc(-7px/2);margin-left:calc(-7px/2);}body.rtl .elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{left:calc(-7px/2);}body:not(.rtl) .elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-items.elementor-inline-items .elementor-icon-list-item:after{right:calc(-7px/2);}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon i{color:#6BC048;transition:color 0.3s;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon svg{fill:#6BC048;transition:fill 0.3s;}.elementor-16741 .elementor-element.elementor-element-3deea0f{--e-icon-list-icon-size:17px;--e-icon-list-icon-align:right;--e-icon-list-icon-margin:0 0 0 calc(var(--e-icon-list-icon-size, 1em) * 0.25);--icon-vertical-offset:0px;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-icon{padding-right:1px;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > .elementor-icon-list-text, .elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-item > a{font-family:"Open Sans", Sans-serif;font-size:16px;letter-spacing:-0.8px;}.elementor-16741 .elementor-element.elementor-element-3deea0f .elementor-icon-list-text{color:#343434;transition:color 0.3s;}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}</style>		<div data-elementor-type="page" data-elementor-id="16741" class="elementor elementor-16741" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementor_library">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-4369bc3 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="4369bc3" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-9e347b3" data-id="9e347b3" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-3deea0f elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="3deea0f" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">It is interest earning.</span>
									</li>
								<li class="elementor-icon-list-item">
											<span class="elementor-icon-list-icon">
							<i aria-hidden="true" class="icon icon-checkmark-circle"></i>						</span>
										<span class="elementor-icon-list-text">Interest earned is taxable</span>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		</div>
                </div></div>		</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		
		
			</div>

	
</main>

			<div data-elementor-type="footer" data-elementor-id="9695" class="elementor elementor-9695 elementor-location-footer" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementor_library">
					<section class="elementor-section elementor-top-section elementor-element elementor-element-24cb887 elementor-section-height-min-height elementor-section-content-middle elementor-section-boxed elementor-section-height-default elementor-section-items-middle" data-id="24cb887" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;418a267&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}],&quot;background_background&quot;:&quot;classic&quot;,&quot;background_motion_fx_motion_fx_scrolling&quot;:&quot;yes&quot;,&quot;background_motion_fx_translateY_effect&quot;:&quot;yes&quot;,&quot;background_motion_fx_translateY_direction&quot;:&quot;negative&quot;,&quot;background_motion_fx_translateY_speed&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:10,&quot;sizes&quot;:[]},&quot;background_motion_fx_range&quot;:&quot;viewport&quot;,&quot;background_motion_fx_translateY_affectedRange&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:{&quot;start&quot;:0,&quot;end&quot;:100}},&quot;background_motion_fx_devices&quot;:[&quot;desktop&quot;,&quot;tablet&quot;,&quot;mobile&quot;]}">
							<div class="elementor-background-overlay"></div>
							<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-3e58891" data-id="3e58891" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-a24103a elementor-widget elementor-widget-heading" data-id="a24103a" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default">Stay Close, We Are Always Here</h2>		</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-50 elementor-top-column elementor-element elementor-element-5f04aad" data-id="5f04aad" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-f3a46eb button-transition elementor-align-center elementor-widget elementor-widget-button" data-id="f3a46eb" data-element_type="widget" data-widget_type="button.default">
				<div class="elementor-widget-container">
							<div class="elementor-button-wrapper">
					<a class="elementor-button elementor-button-link elementor-size-sm" href="https://www.fidelitybank.ng/contact-us/">
						<span class="elementor-button-content-wrapper">
						<span class="elementor-button-icon">
				<i aria-hidden="true" class="fas fa-arrow-right"></i>			</span>
									<span class="elementor-button-text">Get In Touch</span>
					</span>
					</a>
				</div>
						</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-c56420b elementor-section-stretched elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="c56420b" data-element_type="section" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;stretch_section&quot;:&quot;section-stretched&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;9aec421&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-20 elementor-top-column elementor-element elementor-element-66a0dc8" data-id="66a0dc8" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-85ee164 elementor-widget elementor-widget-heading" data-id="85ee164" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default">Banking</h2>		</div>
				</div>
				<div class="elementor-element elementor-element-168ac7e elementor-align-left elementor-mobile-align-left elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="168ac7e" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/">

											<span class="elementor-icon-list-text">Personal Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/sme-academy/">

											<span class="elementor-icon-list-text">SME Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/digital-banking/">

											<span class="elementor-icon-list-text">Digital Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/corporate-banking/">

											<span class="elementor-icon-list-text">Corporate Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/private-banking/">

											<span class="elementor-icon-list-text">Private Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/personal-banking/diaspora-banking/">

											<span class="elementor-icon-list-text">Diaspora Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/agriculture-and-export/">

											<span class="elementor-icon-list-text">Agric & Export Banking</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-20 elementor-top-column elementor-element elementor-element-76fe43c" data-id="76fe43c" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-0eed5ad elementor-widget elementor-widget-heading" data-id="0eed5ad" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default">About Fidelity</h2>		</div>
				</div>
				<div class="elementor-element elementor-element-5e977c4 elementor-align-left elementor-mobile-align-left elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="5e977c4" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/about-us/">

											<span class="elementor-icon-list-text">About Us</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/csr/">

											<span class="elementor-icon-list-text">CSR</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/careers/">

											<span class="elementor-icon-list-text">Careers</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/investor-relations/">

											<span class="elementor-icon-list-text">Investor Relations</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-20 elementor-top-column elementor-element elementor-element-5f7df81" data-id="5f7df81" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-1150f82 elementor-widget elementor-widget-heading" data-id="1150f82" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default">Help &amp; Support</h2>		</div>
				</div>
				<div class="elementor-element elementor-element-f74ff97 elementor-align-left elementor-mobile-align-left elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="f74ff97" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/help-support/">

											<span class="elementor-icon-list-text">Helpdesk</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/contact-us/">

											<span class="elementor-icon-list-text">True Serve </span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/feedback/">

											<span class="elementor-icon-list-text">Voice of Customer</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/help-support/faqs/">

											<span class="elementor-icon-list-text">FAQs</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/branch-locator/">

											<span class="elementor-icon-list-text">Find a Branch</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/contact-us/whistle-blowing/">

											<span class="elementor-icon-list-text">Whistle Blowing</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/information-security/">

											<span class="elementor-icon-list-text">Information Security</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-20 elementor-top-column elementor-element elementor-element-1d6477f" data-id="1d6477f" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-68c94b0 elementor-widget elementor-widget-heading" data-id="68c94b0" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default">Quick Links</h2>		</div>
				</div>
				<div class="elementor-element elementor-element-a84b55b elementor-align-left elementor-mobile-align-left elementor-icon-list--layout-traditional elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="a84b55b" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items">
							<li class="elementor-icon-list-item">
											<a href="https://eserve.fidelitybank.ng/nin_portal/" target="_blank" rel="nofollow">

											<span class="elementor-icon-list-text">NIN Portal</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://online.fidelitybank.ng/">

											<span class="elementor-icon-list-text">Online Banking</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/sme-banking/loan-calculator/">

											<span class="elementor-icon-list-text">Loan Calculator</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/blog/">

											<span class="elementor-icon-list-text">Media</span>
											</a>
									</li>
								<li class="elementor-icon-list-item">
											<a href="https://www.fidelitybank.ng/suspected-pta-bta-racketeers/">

											<span class="elementor-icon-list-text">Suspected Foreign Exchange Racketeers</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
				<div class="elementor-column elementor-col-20 elementor-top-column elementor-element elementor-element-deadc23" data-id="deadc23" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-efd70b3 elementor-widget elementor-widget-heading" data-id="efd70b3" data-element_type="widget" data-widget_type="heading.default">
				<div class="elementor-widget-container">
			<h2 class="elementor-heading-title elementor-size-default">Digital Channels</h2>		</div>
				</div>
		<div class="elementor-element elementor-element-de1109d e-con-full e-flex e-con e-parent" data-id="de1109d" data-element_type="container" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
		<div class="elementor-element elementor-element-643c0aa e-con-full e-flex e-con e-child" data-id="643c0aa" data-element_type="container" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
				<div class="elementor-element elementor-element-1f79894 elementor-widget-mobile__width-initial elementor-widget elementor-widget-image" data-id="1f79894" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
														<a href="https://apps.apple.com/us/app/fidelity-online-banking/id1051038075" target="_blank">
							<img width="540" height="160" src="/wp-content/uploads/2022/12/Apple_Store_Logo.svg" class="elementor-animation-float attachment-full size-full wp-image-41744" alt="" />								</a>
													</div>
				</div>
				<div class="elementor-element elementor-element-97a959d elementor-widget-mobile__width-initial elementor-widget elementor-widget-image" data-id="97a959d" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
														<a href="https://play.google.com/store/apps/details?id=com.interswitchng.www&#038;hl=en" target="_blank">
							<img width="923" height="274" src="/wp-content/uploads/2022/12/Google_Play_Store.svg" class="elementor-animation-float attachment-full size-full wp-image-41743" alt="" />								</a>
													</div>
				</div>
				</div>
				</div>
		<div class="elementor-element elementor-element-f6f9b8f e-con-full e-flex e-con e-parent" data-id="f6f9b8f" data-element_type="container" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
		<div class="elementor-element elementor-element-e29cc10 e-con-full e-flex e-con e-child" data-id="e29cc10" data-element_type="container" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
				<div class="elementor-element elementor-element-8cc32b3 elementor-widget-mobile__width-initial elementor-widget elementor-widget-image" data-id="8cc32b3" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
														<a href="https://wa.me/2349030000302?text=Hello%20IVY" target="_blank">
							<img src="https://migrationdiag472.blob.core.windows.net/newsite2020wpuploadfolder/2020/07/Fidelity-Bank-whatsapp-IVY.svg" class="elementor-animation-float attachment-full size-full wp-image-14107" alt="" />								</a>
													</div>
				</div>
				<div class="elementor-element elementor-element-3ab83ea elementor-widget-mobile__width-initial elementor-widget elementor-widget-image" data-id="3ab83ea" data-element_type="widget" data-widget_type="image.default">
				<div class="elementor-widget-container">
														<a href="tel:*770#" target="_blank">
							<img width="923" height="274" src="/wp-content/uploads/2020/09/770_button_2.svg" class="elementor-animation-float attachment-full size-full wp-image-44080" alt="" />								</a>
													</div>
				</div>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
		<footer class="elementor-element elementor-element-1e955e6 e-flex e-con-boxed e-con e-parent" data-id="1e955e6" data-element_type="container" data-settings="{&quot;background_background&quot;:&quot;classic&quot;,&quot;jet_parallax_layout_list&quot;:[{&quot;jet_parallax_layout_image&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;_id&quot;:&quot;fe07aa9&quot;,&quot;jet_parallax_layout_image_tablet&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_image_mobile&quot;:{&quot;url&quot;:&quot;&quot;,&quot;id&quot;:&quot;&quot;,&quot;size&quot;:&quot;&quot;},&quot;jet_parallax_layout_speed&quot;:{&quot;unit&quot;:&quot;%&quot;,&quot;size&quot;:50,&quot;sizes&quot;:[]},&quot;jet_parallax_layout_type&quot;:&quot;scroll&quot;,&quot;jet_parallax_layout_direction&quot;:null,&quot;jet_parallax_layout_fx_direction&quot;:null,&quot;jet_parallax_layout_z_index&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x&quot;:50,&quot;jet_parallax_layout_bg_x_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_x_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y&quot;:50,&quot;jet_parallax_layout_bg_y_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_y_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size&quot;:&quot;auto&quot;,&quot;jet_parallax_layout_bg_size_tablet&quot;:&quot;&quot;,&quot;jet_parallax_layout_bg_size_mobile&quot;:&quot;&quot;,&quot;jet_parallax_layout_animation_prop&quot;:&quot;transform&quot;,&quot;jet_parallax_layout_on&quot;:[&quot;desktop&quot;,&quot;tablet&quot;]}]}">
					<div class="e-con-inner">
		<div class="elementor-element elementor-element-bbc72b1 e-con-full e-flex e-con e-child" data-id="bbc72b1" data-element_type="container" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
				<div class="elementor-element elementor-element-3d6beb3 elementor-widget__width-initial elementor-widget elementor-widget-text-editor" data-id="3d6beb3" data-element_type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
							<p>© 2024 Fidelity Bank Plc. RC 103022 (Licensed by the Central Bank of Nigeria). All Rights Reserved.</p>						</div>
				</div>
				<div class="elementor-element elementor-element-a7c0504 elementor-widget elementor-widget-text-editor" data-id="a7c0504" data-element_type="widget" data-widget_type="text-editor.default">
				<div class="elementor-widget-container">
							<p><span class="footer-text-style"><span style="color: #666;"><a href="https://www.fidelitybank.ng/privacy-policy/" target="_blank" rel="noopener">Privacy Policy</a> | <a href="https://www.fidelitybank.ng/documents/Cookie-Policy.pdf" target="_blank" rel="noopener">Cookie Policy</a> | <a href="https://www.fidelitybank.ng/documents/Fidelity-Bank-Plc-communication-policy-2021.pdf" target="_blank" rel="noopener">Communication Policy</a> | <a href="https://www.fidelitybank.ng/terms-and-conditions/">Terms and Conditions</a> | <a href="https://www.fidelitybank.ng/site-map/">Sitemap</a></span></span></p>						</div>
				</div>
				</div>
					</div>
				</footer>
				</div>
		

		<script type="4364f5cca7525295a0b533ca-text/javascript">
			window.RS_MODULES = window.RS_MODULES || {};
			window.RS_MODULES.modules = window.RS_MODULES.modules || {};
			window.RS_MODULES.waiting = window.RS_MODULES.waiting || [];
			window.RS_MODULES.defered = true;
			window.RS_MODULES.moduleWaiting = window.RS_MODULES.moduleWaiting || {};
			window.RS_MODULES.type = 'compiled';
		</script>
		<script id="wccBannerTemplate_GDPR" type="text/template"><div class="wcc-overlay wcc-hide"></div><div class="wcc-btn-revisit-wrapper wcc-revisit-hide" data-tag="revisit-consent" data-tooltip="Cookie Settings"> <button class="wcc-btn-revisit" aria-label="Cookie Settings"> <img src="/wp-content/plugins/webtoffee-cookie-consent/lite/frontend/images/revisit.svg" alt="Revisit consent button"> </button> <span class="wcc-revisit-help-text"> Cookie Settings </span></div><div class="wcc-consent-container wcc-hide wcc-popup-center"> <div class="wcc-consent-bar" data-tag="notice" style="background-color:#FFFFFF;border-color:#f4f4f4">  <div class="wcc-notice"> <p class="wcc-title" data-tag="title" style="color:#002082">Privacy/Cookie Statement</p><div class="wcc-notice-group"> <div class="wcc-notice-des" data-tag="description" style="color:#002082"> <p>We take your privacy seriously and only process your personal information to make your banking experience better. In accordance with NDPR (2019) and NDPA (2023), continuing to use this platform indicates your consent to the processing of your personal data by Fidelity Bank Plc, its subsidiaries and third-party processors as detailed in our <a href="https://www.fidelitybank.ng/privacy-policy/" target="_blank" style="color: #6BC048">Privacy Policy</a>.</p>
<p>Our website also uses cookies to enhance your experience while you are here, We also use cookie to personalize your journey on our website. Click on ‘Cookie Setting’ to specify your preference. For more details about the cookies we use, read our <a href="https://www.fidelitybank.ng/documents/Cookie-Policy.pdf" target="_blank" style="color: #6BC048">cookie policy</a>.</p> </div><div class="wcc-notice-btn-wrapper" data-tag="notice-buttons"> <button class="wcc-btn wcc-btn-customize" aria-label="Cookie Settings" data-tag="settings-button" style="color:#002082;background-color:transparent;border-color:#002082">Cookie Settings</button> <button class="wcc-btn wcc-btn-reject" aria-label="Reject All" data-tag="reject-button" style="color:#002082;background-color:transparent;border-color:#002082">Reject All</button> <button class="wcc-btn wcc-btn-accept" aria-label="Accept All" data-tag="accept-button" style="color:#FFFFFF;background-color:#002082;border-color:#002082">Accept All</button>  </div></div></div></div></div><div class="wcc-modal"> <div class="wcc-preference-center" data-tag="detail" style="color:#002082;background-color:#FFFFFF;border-color:#f4f4f4"> <div class="wcc-preference-header"> <span class="wcc-preference-title" data-tag="detail-title" style="color:#002082">Privacy Overview</span> <button class="wcc-btn-close" aria-label="[wcc_preference_close_label]" data-tag="detail-close"> <img src="/wp-content/plugins/webtoffee-cookie-consent/lite/frontend/images/close.svg" alt="Close"> </button> </div><div class="wcc-preference-body-wrapper"> <div class="wcc-preference-content-wrapper" data-tag="detail-description" style="color:#002082"> <p>This website uses cookies so that we can provide you with the best user experience possible. Cookie information is stored in your browser and performs functions such as recognising you when you return to our website and helping our team to understand which sections of the website you find most interesting and useful.<br><br><a href="https://www.fidelitybank.ng/privacy-policy/">Click Here</a> to read more about our privacy policy.</p> </div><div class="wcc-accordion-wrapper" data-tag="detail-categories"> <div class="wcc-accordion" id="wccDetailCategorynecessary"> <div class="wcc-accordion-item"> <div class="wcc-accordion-chevron"><i class="wcc-chevron-right"></i></div> <div class="wcc-accordion-header-wrapper"> <div class="wcc-accordion-header"><button class="wcc-accordion-btn" aria-label="Necessary" data-tag="detail-category-title" style="color:#002082">Necessary</button><span class="wcc-always-active">Always Active</span> <div class="wcc-switch" data-tag="detail-category-toggle"><input type="checkbox" id="wccSwitchnecessary"></div> </div> <div class="wcc-accordion-header-des" data-tag="detail-category-description" style="color:#002082"> <p>Necessary cookies are required to enable the basic features of this site, such as providing secure log-in or adjusting your consent preferences. These cookies do not store any personally identifiable data.</p></div> </div> </div> <div class="wcc-accordion-body"> <div class="wcc-audit-table" data-tag="audit-table" style="color:#212121;background-color:#f4f4f4;border-color:#ebebeb"><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>elementor</div></li><li><div>Duration</div><div>never</div></li><li><div>Description</div><div>The website's WordPress theme uses this cookie. It allows the website owner to implement or change the website's content in real-time.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>__cf_bm</div></li><li><div>Duration</div><div>1 hour</div></li><li><div>Description</div><div>This cookie, set by Cloudflare, is used to support Cloudflare Bot Management. </div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>wt_consent</div></li><li><div>Duration</div><div>session</div></li><li><div>Description</div><div>Used for remembering users’ consent preferences to be respected on subsequent site visits. It does not collect or store personal information about visitors to the site.</div></li></ul></div> </div> </div><div class="wcc-accordion" id="wccDetailCategoryfunctional"> <div class="wcc-accordion-item"> <div class="wcc-accordion-chevron"><i class="wcc-chevron-right"></i></div> <div class="wcc-accordion-header-wrapper"> <div class="wcc-accordion-header"><button class="wcc-accordion-btn" aria-label="Functional" data-tag="detail-category-title" style="color:#002082">Functional</button><span class="wcc-always-active">Always Active</span> <div class="wcc-switch" data-tag="detail-category-toggle"><input type="checkbox" id="wccSwitchfunctional"></div> </div> <div class="wcc-accordion-header-des" data-tag="detail-category-description" style="color:#002082"> <p>Functional cookies help perform certain functionalities like sharing the content of the website on social media platforms, collecting feedback, and other third-party features.</p></div> </div> </div> <div class="wcc-accordion-body"> <div class="wcc-audit-table" data-tag="audit-table" style="color:#212121;background-color:#f4f4f4;border-color:#ebebeb"><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>ytidb::LAST_RESULT_ENTRY_KEY</div></li><li><div>Duration</div><div>never</div></li><li><div>Description</div><div>The cookie ytidb::LAST_RESULT_ENTRY_KEY is used by YouTube to store the last search result entry that was clicked by the user. This information is used to improve the user experience by providing more relevant search results in the future.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>yt-remote-device-id</div></li><li><div>Duration</div><div>never</div></li><li><div>Description</div><div>YouTube sets this cookie to store the user's video preferences using embedded YouTube videos.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>yt-remote-connected-devices</div></li><li><div>Duration</div><div>never</div></li><li><div>Description</div><div>YouTube sets this cookie to store the user's video preferences using embedded YouTube videos.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>yt-remote-session-app</div></li><li><div>Duration</div><div>session</div></li><li><div>Description</div><div>The yt-remote-session-app cookie is used by YouTube to store user preferences and information about the interface of the embedded YouTube video player.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>yt-remote-session-name</div></li><li><div>Duration</div><div>session</div></li><li><div>Description</div><div>The yt-remote-session-name cookie is used by YouTube to store the user's video player preferences using embedded YouTube video.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>yt-remote-fast-check-period</div></li><li><div>Duration</div><div>session</div></li><li><div>Description</div><div>The yt-remote-fast-check-period cookie is used by YouTube to store the user's video player preferences for embedded YouTube videos.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>_dc_gtm_UA-*</div></li><li><div>Duration</div><div>1 minute</div></li><li><div>Description</div><div>Google Analytics sets this cookie to load the Google Analytics script tag.</div></li></ul></div> </div> </div><div class="wcc-accordion" id="wccDetailCategoryanalytics"> <div class="wcc-accordion-item"> <div class="wcc-accordion-chevron"><i class="wcc-chevron-right"></i></div> <div class="wcc-accordion-header-wrapper"> <div class="wcc-accordion-header"><button class="wcc-accordion-btn" aria-label="Analytics" data-tag="detail-category-title" style="color:#002082">Analytics</button><span class="wcc-always-active">Always Active</span> <div class="wcc-switch" data-tag="detail-category-toggle"><input type="checkbox" id="wccSwitchanalytics"></div> </div> <div class="wcc-accordion-header-des" data-tag="detail-category-description" style="color:#002082"> <p>Analytical cookies are used to understand how visitors interact with the website. These cookies help provide information on metrics such as the number of visitors, bounce rate, traffic source, etc.</p></div> </div> </div> <div class="wcc-accordion-body"> <div class="wcc-audit-table" data-tag="audit-table" style="color:#212121;background-color:#f4f4f4;border-color:#ebebeb"><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>Google Analytics</div></li><li><div>Duration</div><div>3 months</div></li><li><div>Description</div><div><p>Google Analytics sets these cookie to store and count page views, store a unique user ID.</p>
<p>Google Analytics sets these cookie to calculate visitor, session and campaign data and track site usage for the site's analytics report. The cookie stores information anonymously and assigns a randomly generated number to recognise unique visitors.</p>
<p>Also to store information on how visitors use a website while also creating an analytics report of the website's performance. Some of the collected data includes the number of visitors, their source, and the pages they visit anonymously.</p></div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>YouTube</div></li><li><div>Duration</div><div>6 months</div></li><li><div>Description</div><div><p>CONSENT - YouTube sets this cookie via embedded YouTube videos and registers anonymous statistical data.</p>
<p>YSC - Youtube sets this cookie to track the views of embedded videos on Youtube pages.</p>
<p>VISITOR_INFO1_LIVE - YouTube sets this cookie to measure bandwidth, determining whether the user gets the new or old player interface.</p>
<p>VISITOR_PRIVACY_METADATA - YouTube sets this cookie to store the user's cookie consent state for the current domain.</p>
<p>yt-remote-device-id - YouTube sets this cookie to store the user's video preferences using embedded YouTube videos.</p>
<p>yt.innertube::requests - YouTube sets this cookie to register a unique ID to store data on what videos from YouTube the user has seen.</p>
<p>yt.innertube::nextId - YouTube sets this cookie to register a unique ID to store data on what videos from YouTube the user has seen.</p>
<p>yt-remote-connected-devices - YouTube sets this cookie to store the user's video preferences using embedded YouTube videos.</p></div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>Netcore</div></li><li><div>Duration</div><div>session</div></li><li><div>Description</div><div><p>Following code is required to be present on your website to enable Web Push and  <span class="text-bold">Web Activity Tracking on Netcore Platform</span></p></div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>_ga_*</div></li><li><div>Duration</div><div>1 year 1 month 4 days</div></li><li><div>Description</div><div>Google Analytics sets this cookie to store and count page views.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>_ga</div></li><li><div>Duration</div><div>1 year 1 month 4 days</div></li><li><div>Description</div><div>Google Analytics sets this cookie to calculate visitor, session and campaign data and track site usage for the site's analytics report. The cookie stores information anonymously and assigns a randomly generated number to recognise unique visitors.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>_gcl_au</div></li><li><div>Duration</div><div>3 months</div></li><li><div>Description</div><div>Google Tag Manager sets the cookie to experiment advertisement efficiency of websites using their services.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>_gid</div></li><li><div>Duration</div><div>1 day</div></li><li><div>Description</div><div>Google Analytics sets this cookie to store information on how visitors use a website while also creating an analytics report of the website's performance. Some of the collected data includes the number of visitors, their source, and the pages they visit anonymously.</div></li></ul></div> </div> </div><div class="wcc-accordion" id="wccDetailCategoryperformance"> <div class="wcc-accordion-item"> <div class="wcc-accordion-chevron"><i class="wcc-chevron-right"></i></div> <div class="wcc-accordion-header-wrapper"> <div class="wcc-accordion-header"><button class="wcc-accordion-btn" aria-label="Performance" data-tag="detail-category-title" style="color:#002082">Performance</button><span class="wcc-always-active">Always Active</span> <div class="wcc-switch" data-tag="detail-category-toggle"><input type="checkbox" id="wccSwitchperformance"></div> </div> <div class="wcc-accordion-header-des" data-tag="detail-category-description" style="color:#002082"> <p>Performance cookies are used to understand and analyze the key performance indexes of the website which helps in delivering a better user experience for the visitors.</p></div> </div> </div> <div class="wcc-accordion-body"> <div class="wcc-audit-table" data-tag="audit-table" style="color:#212121;background-color:#f4f4f4;border-color:#ebebeb"><p class="wcc-empty-cookies-text">No cookies to display.</p></div> </div> </div><div class="wcc-accordion" id="wccDetailCategoryadvertisement"> <div class="wcc-accordion-item"> <div class="wcc-accordion-chevron"><i class="wcc-chevron-right"></i></div> <div class="wcc-accordion-header-wrapper"> <div class="wcc-accordion-header"><button class="wcc-accordion-btn" aria-label="Advertisement" data-tag="detail-category-title" style="color:#002082">Advertisement</button><span class="wcc-always-active">Always Active</span> <div class="wcc-switch" data-tag="detail-category-toggle"><input type="checkbox" id="wccSwitchadvertisement"></div> </div> <div class="wcc-accordion-header-des" data-tag="detail-category-description" style="color:#002082"> <p>Advertisement cookies are used to provide visitors with customized advertisements based on the pages you visited previously and to analyze the effectiveness of the ad campaigns.</p></div> </div> </div> <div class="wcc-accordion-body"> <div class="wcc-audit-table" data-tag="audit-table" style="color:#212121;background-color:#f4f4f4;border-color:#ebebeb"><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>YSC</div></li><li><div>Duration</div><div>session</div></li><li><div>Description</div><div>Youtube sets this cookie to track the views of embedded videos on Youtube pages.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>VISITOR_INFO1_LIVE</div></li><li><div>Duration</div><div>6 months</div></li><li><div>Description</div><div>YouTube sets this cookie to measure bandwidth, determining whether the user gets the new or old player interface.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>VISITOR_PRIVACY_METADATA</div></li><li><div>Duration</div><div>6 months</div></li><li><div>Description</div><div>YouTube sets this cookie to store the user's cookie consent state for the current domain.	</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>yt.innertube::nextId</div></li><li><div>Duration</div><div>never</div></li><li><div>Description</div><div>YouTube sets this cookie to register a unique ID to store data on what videos from YouTube the user has seen.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>yt.innertube::requests</div></li><li><div>Duration</div><div>never</div></li><li><div>Description</div><div>YouTube sets this cookie to register a unique ID to store data on what videos from YouTube the user has seen.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>ck</div></li><li><div>Duration</div><div>session</div></li><li><div>Description</div><div>The ck cookie is set by AddThis to help in knowing about the users that visit their webpages.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>test_cookie</div></li><li><div>Duration</div><div>15 minutes</div></li><li><div>Description</div><div>doubleclick.net sets this cookie to determine if the user's browser supports cookies.</div></li></ul></div> </div> </div><div class="wcc-accordion" id="wccDetailCategoryothers"> <div class="wcc-accordion-item"> <div class="wcc-accordion-chevron"><i class="wcc-chevron-right"></i></div> <div class="wcc-accordion-header-wrapper"> <div class="wcc-accordion-header"><button class="wcc-accordion-btn" aria-label="Others" data-tag="detail-category-title" style="color:#002082">Others</button><span class="wcc-always-active">Always Active</span> <div class="wcc-switch" data-tag="detail-category-toggle"><input type="checkbox" id="wccSwitchothers"></div> </div> <div class="wcc-accordion-header-des" data-tag="detail-category-description" style="color:#002082"> <p>Other cookies are those that are being identified and have not been classified into any category as yet.</p></div> </div> </div> <div class="wcc-accordion-body"> <div class="wcc-audit-table" data-tag="audit-table" style="color:#212121;background-color:#f4f4f4;border-color:#ebebeb"><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>_gat_G-Q351SFPM7R</div></li><li><div>Duration</div><div>1 minute</div></li><li><div>Description</div><div>Description is currently not available.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>__sts</div></li><li><div>Duration</div><div>1 hour</div></li><li><div>Description</div><div>No description available.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>__stp</div></li><li><div>Duration</div><div>1 year 1 month 4 days</div></li><li><div>Description</div><div>No description available.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>__stdf</div></li><li><div>Duration</div><div>10 days</div></li><li><div>Description</div><div>No description available.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>__stgeo</div></li><li><div>Duration</div><div>1 day</div></li><li><div>Description</div><div>No description available.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>__stbpnenable</div></li><li><div>Duration</div><div>1 day</div></li><li><div>Description</div><div>No description available.</div></li></ul><ul class="wcc-cookie-des-table"><li><div>Cookie</div><div>__stat</div></li><li><div>Duration</div><div>1 year 1 month 4 days</div></li><li><div>Description</div><div>No description available.</div></li></ul></div> </div> </div> </div></div><div class="wcc-footer-wrapper"> <span class="wcc-footer-shadow"></span> <div class="wcc-prefrence-btn-wrapper" data-tag="detail-buttons"> <button class="wcc-btn wcc-btn-reject" aria-label="Reject All" data-tag="detail-reject-button" style="color:#002082;background-color:transparent;border-color:#002082"> Reject All </button> <button class="wcc-btn wcc-btn-preferences" aria-label="Save My Preferences" data-tag="detail-save-button" style="color:#002082;background-color:transparent;border-color:#002082"> Save My Preferences </button> <button class="wcc-btn wcc-btn-accept" aria-label="Accept All" data-tag="detail-accept-button" style="color:#FFFFFF;background-color:#002082;border-color:#002082"> Accept All </button> </div></div></div></div></script>
<!-- WP Socializer 7.8 - JS - Start -->

<!-- WP Socializer - JS - End -->
<style id="elementor-post-37410">.elementor-37410 .elementor-element.elementor-element-4b93d49d:not(.elementor-motion-effects-element-type-background) > .elementor-widget-wrap, .elementor-37410 .elementor-element.elementor-element-4b93d49d > .elementor-widget-wrap > .elementor-motion-effects-container > .elementor-motion-effects-layer{background-color:var( --e-global-color-accent );}.elementor-37410 .elementor-element.elementor-element-4b93d49d > .elementor-element-populated{transition:background 0.3s, border 0.3s, border-radius 0.3s, box-shadow 0.3s;padding:30px 20px 20px 20px;}.elementor-37410 .elementor-element.elementor-element-4b93d49d > .elementor-element-populated > .elementor-background-overlay{transition:background 0.3s, border-radius 0.3s, opacity 0.3s;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-nav .elementkit-nav-link.active{background-color:#FFFFFF4D;color:#002082;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .tab-content .tab-pane{background-color:#FFFFFF4D;color:#FFFFFF;padding:15px 10px 15px 10px;border-radius:0px 0px 4px 4px;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-wraper .elementkit-nav-link.left-pos .elementskit-tab-icon{margin-right:10px;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-wraper .elementkit-nav-link.left-pos .ekit-icon-image{margin-right:10px;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-wraper .elementkit-nav-link{justify-content:center;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-nav{padding:0px 0px 0px 0px;margin:0px 0px 0px 0px;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-nav .elementkit-nav-item .elementkit-nav-link{font-size:13px;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-wraper:not(.vertical) .elementkit-nav-item:not(:last-child){margin-right:10px;}.rtl .elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-wraper:not(.vertical) .elementkit-nav-item:not(:last-child){margin-left:10px;margin-right:0;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-wraper.vertical .elementkit-tab-nav{margin-right:10px;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-wraper.vertical .elementkit-nav-item:not(:last-child){margin-bottom:0px;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-wraper:not(.vertical) .elementkit-tab-nav{margin-bottom:0px;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-nav .elementkit-nav-link{padding:12px 35px 12px 35px;color:#333333;border-style:solid;border-width:1px 1px 1px 1px;border-color:#2575FC00;}.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-nav .elementkit-nav-item a.elementkit-nav-link{border-radius:4px 4px 0px 0px;}#elementor-popup-modal-37410{background-color:#FFFFFF80;justify-content:center;align-items:center;pointer-events:all;}#elementor-popup-modal-37410 .dialog-message{width:640px;height:auto;}#elementor-popup-modal-37410 .dialog-close-button{display:flex;top:5.3%;}#elementor-popup-modal-37410 .dialog-widget-content{box-shadow:2px 8px 23px 3px rgba(0,0,0,0.2);}.elementor-widget .tippy-tooltip .tippy-content{text-align:center;}body:not(.rtl) #elementor-popup-modal-37410 .dialog-close-button{right:1.9%;}body.rtl #elementor-popup-modal-37410 .dialog-close-button{left:1.9%;}@media(max-width:1024px){.elementor-37410 .elementor-element.elementor-element-5e7cfa05 .elementkit-tab-nav{padding:0px 0px 0px 0px;margin:0px 0px 0px 0px;}}@media(max-width:767px){.elementor-37410 .elementor-element.elementor-element-8d4d1c3{padding:16px 16px 16px 16px;}.elementor-37410 .elementor-element.elementor-element-4b93d49d > .elementor-element-populated{padding:20px 10px 20px 10px;}#elementor-popup-modal-37410 .dialog-close-button{top:9.7%;}body:not(.rtl) #elementor-popup-modal-37410 .dialog-close-button{right:3%;}body.rtl #elementor-popup-modal-37410 .dialog-close-button{left:3%;}}</style>		<div data-elementor-type="popup" data-elementor-id="37410" class="elementor elementor-37410 elementor-location-popup" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;a11y_navigation&quot;:&quot;yes&quot;,&quot;timing&quot;:{&quot;devices_devices&quot;:[&quot;tablet&quot;,&quot;mobile&quot;],&quot;devices&quot;:&quot;yes&quot;}}" data-elementor-post-type="elementor_library">
					<section class="elementor-section elementor-top-section elementor-element elementor-element-8d4d1c3 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="8d4d1c3" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-4b93d49d" data-id="4b93d49d" data-element_type="column" data-settings="{&quot;background_background&quot;:&quot;classic&quot;}">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-5e7cfa05 elementor-widget elementor-widget-elementskit-simple-tab" data-id="5e7cfa05" data-element_type="widget" data-widget_type="elementskit-simple-tab.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" >        <div class="elementkit-tab-wraper  ">
            <ul class="nav nav-tabs elementkit-tab-nav  elementskit-fullwidth-tab">
                                    <li class="elementkit-nav-item elementor-repeater-item-1ec743b">
                        <a class="elementkit-nav-link  active show left-pos" id="content-1ec743b673c8ad8bccd7-tab" data-ekit-handler-id="personal" data-ekit-toggle="tab" data-target="#content-1ec743b673c8ad8bccd7" href="#Content-1ec743b673c8ad8bccd7"
                            data-ekit-toggle-trigger="click"
                            aria-describedby="Content-1ec743b673c8ad8bccd7">
                                                        <span class="elementskit-tab-title"> Personal</span>
                        </a>
                    </li>
                                        <li class="elementkit-nav-item elementor-repeater-item-73acd0a">
                        <a class="elementkit-nav-link  left-pos" id="content-73acd0a673c8ad8bccd7-tab" data-ekit-handler-id="corporate" data-ekit-toggle="tab" data-target="#content-73acd0a673c8ad8bccd7" href="#Content-73acd0a673c8ad8bccd7"
                            data-ekit-toggle-trigger="click"
                            aria-describedby="Content-73acd0a673c8ad8bccd7">
                                                        <span class="elementskit-tab-title"> Corporate</span>
                        </a>
                    </li>
                                </ul>

            <div class="tab-content elementkit-tab-content">
                                    <div class="tab-pane elementkit-tab-pane elementor-repeater-item-1ec743b  active show" id="content-1ec743b673c8ad8bccd7" role="tabpanel"
                         aria-labelledby="content-1ec743b673c8ad8bccd7-tab">
                        <div class="animated fadeIn">
                            		<div data-elementor-type="section" data-elementor-id="37365" class="elementor elementor-37365 elementor-location-popup" data-elementor-post-type="elementor_library">
					<section class="elementor-section elementor-top-section elementor-element elementor-element-3bfca37 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="3bfca37" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-031c722" data-id="031c722" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-c272d34 elementor-widget elementor-widget-elementskit-button" data-id="c272d34" data-element_type="widget" data-widget_type="elementskit-button.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" >		<div class="ekit-btn-wraper">
							<a href="https://online.fidelitybank.ng" class="elementskit-btn  whitespace--normal" id="">
					<i aria-hidden="true" class="icon- icon-lock"></i>Login				</a>
					</div>
        </div>		</div>
				</div>
				<div class="elementor-element elementor-element-b678a70 elementor-icon-list--layout-inline elementor-align-center elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="b678a70" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items elementor-inline-items">
							<li class="elementor-icon-list-item elementor-inline-item">
											<a href="https://online.fidelitybank.ng/#/reg/guide/RETAIL_REG_ONLINE">

											<span class="elementor-icon-list-text">Register</span>
											</a>
									</li>
								<li class="elementor-icon-list-item elementor-inline-item">
										<span class="elementor-icon-list-text">|</span>
									</li>
								<li class="elementor-icon-list-item elementor-inline-item">
											<a href="https://eserve.fidelitybank.ng/oap/">

											<span class="elementor-icon-list-text">Open New Account</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		                        </div>
                    </div>
                                    <div class="tab-pane elementkit-tab-pane elementor-repeater-item-73acd0a " id="content-73acd0a673c8ad8bccd7" role="tabpanel"
                         aria-labelledby="content-73acd0a673c8ad8bccd7-tab">
                        <div class="animated fadeIn">
                            		<div data-elementor-type="page" data-elementor-id="37381" class="elementor elementor-37381" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true}}" data-elementor-post-type="elementor_library">
						<section class="elementor-section elementor-top-section elementor-element elementor-element-3bfca37 elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="3bfca37" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-031c722" data-id="031c722" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-c272d34 elementor-widget elementor-widget-elementskit-button" data-id="c272d34" data-element_type="widget" data-widget_type="elementskit-button.default">
				<div class="elementor-widget-container">
			<div class="ekit-wid-con" >		<div class="ekit-btn-wraper">
							<a href="https://conb.fidelitybank.ng" class="elementskit-btn  whitespace--normal" id="">
					<i aria-hidden="true" class="icon- icon-lock"></i>Login				</a>
					</div>
        </div>		</div>
				</div>
				<div class="elementor-element elementor-element-b678a70 elementor-icon-list--layout-inline elementor-align-center elementor-list-item-link-full_width elementor-widget elementor-widget-icon-list" data-id="b678a70" data-element_type="widget" data-widget_type="icon-list.default">
				<div class="elementor-widget-container">
					<ul class="elementor-icon-list-items elementor-inline-items">
							<li class="elementor-icon-list-item elementor-inline-item">
											<a href="https://conb.fidelitybank.ng/#/reg/guide/RETAIL_REG_ONLINE">

											<span class="elementor-icon-list-text">Register</span>
											</a>
									</li>
								<li class="elementor-icon-list-item elementor-inline-item">
										<span class="elementor-icon-list-text">|</span>
									</li>
								<li class="elementor-icon-list-item elementor-inline-item">
											<a href="https://eserve.fidelitybank.ng/oap/">

											<span class="elementor-icon-list-text">Open New Account</span>
											</a>
									</li>
						</ul>
				</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
		                        </div>
                    </div>
                                
            </div>
                    </div>
    </div>		</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
				<div data-elementor-type="popup" data-elementor-id="10004" class="elementor elementor-10004 elementor-location-popup" data-elementor-settings="{&quot;element_pack_global_tooltip_width&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_width_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;size&quot;:&quot;&quot;,&quot;sizes&quot;:[]},&quot;element_pack_global_tooltip_padding&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_padding_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_tablet&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;element_pack_global_tooltip_border_radius_mobile&quot;:{&quot;unit&quot;:&quot;px&quot;,&quot;top&quot;:&quot;&quot;,&quot;right&quot;:&quot;&quot;,&quot;bottom&quot;:&quot;&quot;,&quot;left&quot;:&quot;&quot;,&quot;isLinked&quot;:true},&quot;a11y_navigation&quot;:&quot;yes&quot;,&quot;triggers&quot;:[],&quot;timing&quot;:[]}" data-elementor-post-type="elementor_library">
					<section class="elementor-section elementor-top-section elementor-element elementor-element-3ec1cc8 elementor-section-height-min-height elementor-section-items-top elementor-section-content-top elementor-section-boxed elementor-section-height-default" data-id="3ec1cc8" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-cfc7ecf" data-id="cfc7ecf" data-element_type="column">
			<div class="elementor-widget-wrap elementor-element-populated">
						<div class="elementor-element elementor-element-665dbf8 elementor-align-center elementor-widget elementor-widget-button" data-id="665dbf8" data-element_type="widget" data-widget_type="button.default">
				<div class="elementor-widget-container">
							<div class="elementor-button-wrapper">
					<a class="elementor-button elementor-button-link elementor-size-sm" href="#">
						<span class="elementor-button-content-wrapper">
									<span class="elementor-button-text">Personal</span>
					</span>
					</a>
				</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-2f7bf35 elementor-align-center elementor-widget elementor-widget-button" data-id="2f7bf35" data-element_type="widget" data-widget_type="button.default">
				<div class="elementor-widget-container">
							<div class="elementor-button-wrapper">
					<a class="elementor-button elementor-button-link elementor-size-sm" href="#">
						<span class="elementor-button-content-wrapper">
									<span class="elementor-button-text">Corporate</span>
					</span>
					</a>
				</div>
						</div>
				</div>
					</div>
		</div>
					</div>
		</section>
				</div>
					<script type="4364f5cca7525295a0b533ca-text/javascript">
				const lazyloadRunObserver = () => {
					const lazyloadBackgrounds = document.querySelectorAll( `.e-con.e-parent:not(.e-lazyloaded)` );
					const lazyloadBackgroundObserver = new IntersectionObserver( ( entries ) => {
						entries.forEach( ( entry ) => {
							if ( entry.isIntersecting ) {
								let lazyloadBackground = entry.target;
								if( lazyloadBackground ) {
									lazyloadBackground.classList.add( 'e-lazyloaded' );
								}
								lazyloadBackgroundObserver.unobserve( entry.target );
							}
						});
					}, { rootMargin: '200px 0px 200px 0px' } );
					lazyloadBackgrounds.forEach( ( lazyloadBackground ) => {
						lazyloadBackgroundObserver.observe( lazyloadBackground );
					} );
				};
				const events = [
					'DOMContentLoaded',
					'elementor/lazyload/observe',
				];
				events.forEach( ( event ) => {
					document.addEventListener( event, lazyloadRunObserver );
				} );
			</script>
			<style id="eael-inline-css">.clearfix::before,.clearfix::after{content:" ";display:table;clear:both}.eael-testimonial-slider.nav-top-left,.eael-testimonial-slider.nav-top-right,.eael-team-slider.nav-top-left,.eael-team-slider.nav-top-right,.eael-logo-carousel.nav-top-left,.eael-logo-carousel.nav-top-right,.eael-post-carousel.nav-top-left,.eael-post-carousel.nav-top-right,.eael-product-carousel.nav-top-left,.eael-product-carousel.nav-top-right{padding-top:40px}.eael-contact-form input[type=text],.eael-contact-form input[type=email],.eael-contact-form input[type=url],.eael-contact-form input[type=tel],.eael-contact-form input[type=date],.eael-contact-form input[type=number],.eael-contact-form textarea{background:#fff;box-shadow:none;-webkit-box-shadow:none;float:none;height:auto;margin:0;outline:0;width:100%}.eael-contact-form input[type=submit]{border:0;float:none;height:auto;margin:0;padding:10px 20px;width:auto;-webkit-transition:all .25s linear 0s;transition:all .25s linear 0s}.eael-contact-form.placeholder-hide input::-webkit-input-placeholder,.eael-contact-form.placeholder-hide textarea::-webkit-input-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input::-moz-placeholder,.eael-contact-form.placeholder-hide textarea::-moz-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input:-ms-input-placeholder,.eael-contact-form.placeholder-hide textarea:-ms-input-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input:-moz-placeholder,.eael-contact-form.placeholder-hide textarea:-moz-placeholder{opacity:0;visibility:hidden}.eael-custom-radio-checkbox input[type=checkbox],.eael-custom-radio-checkbox input[type=radio]{-webkit-appearance:none;-moz-appearance:none;border-style:solid;border-width:0;outline:none;min-width:1px;width:15px;height:15px;background:#ddd;padding:3px}.eael-custom-radio-checkbox input[type=checkbox]:before,.eael-custom-radio-checkbox input[type=radio]:before{content:"";width:100%;height:100%;padding:0;margin:0;display:block}.eael-custom-radio-checkbox input[type=checkbox]:checked:before,.eael-custom-radio-checkbox input[type=radio]:checked:before{background:#999;-webkit-transition:all .25s linear 0s;transition:all .25s linear 0s}.eael-custom-radio-checkbox input[type=radio]{border-radius:50%}.eael-custom-radio-checkbox input[type=radio]:before{border-radius:50%}.eael-post-elements-readmore-btn{font-size:12px;font-weight:500;-webkit-transition:all 300ms ease-in-out;transition:all 300ms ease-in-out;display:inline-block}.elementor-lightbox .dialog-widget-content{width:100%;height:100%}.eael-contact-form-align-left,.elementor-widget-eael-weform.eael-contact-form-align-left .eael-weform-container{margin:0 auto 0 0;display:inline-block;text-align:left}.eael-contact-form-align-center,.elementor-widget-eael-weform.eael-contact-form-align-center .eael-weform-container{float:none;margin:0 auto;display:inline-block;text-align:left}.eael-contact-form-align-right,.elementor-widget-eael-weform.eael-contact-form-align-right .eael-weform-container{margin:0 0 0 auto;display:inline-block;text-align:left}.eael-force-hide{display:none !important}.eael-d-none{display:none !important}.eael-d-block{display:block !important}.eael-h-auto{height:auto !important}.theme-martfury .elementor-wc-products .woocommerce ul.products li.product .product-inner .mf-rating .eael-star-rating.star-rating{display:none}.theme-martfury .elementor-wc-products .woocommerce ul.products li.product .product-inner .mf-rating .eael-star-rating.star-rating~.count{display:none}.sr-only{border:0 !important;clip:rect(1px, 1px, 1px, 1px) !important;clip-path:inset(50%) !important;height:1px !important;margin:-1px !important;overflow:hidden !important;padding:0 !important;position:absolute !important;width:1px !important;white-space:nowrap !important}.elementor-widget-eael-adv-tabs .eael-tab-content-item,.elementor-widget-eael-adv-accordion .eael-accordion-content{position:relative}.elementor-widget-eael-adv-tabs .eael-tab-content-item:hover .eael-onpage-edit-template-wrapper,.elementor-widget-eael-adv-accordion .eael-accordion-content:hover .eael-onpage-edit-template-wrapper{display:block}.eael-widget-otea-active .elementor-element:hover>.elementor-element-overlay,.eael-widget-otea-active .elementor-empty-view,.eael-widget-otea-active .elementor-add-section-inline,.eael-widget-otea-active .elementor-add-section{display:initial !important}.eael-onpage-edit-template-wrapper{position:absolute;top:0;left:0;width:100%;height:100%;display:none;border:2px solid #5eead4}.eael-onpage-edit-template-wrapper::after{position:absolute;content:"";top:0;left:0;right:0;bottom:0;z-index:2;background:#5eead4;opacity:.3}.eael-onpage-edit-template-wrapper.eael-onpage-edit-activate{display:block}.eael-onpage-edit-template-wrapper.eael-onpage-edit-activate::after{display:none}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template{background:#5eead4;color:#000;width:150px;text-align:center;height:30px;line-height:30px;font-size:12px;cursor:pointer;position:relative;z-index:3;left:50%;-webkit-transform:translateX(-50%);-ms-transform:translateX(-50%);transform:translateX(-50%)}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template::before{content:"";border-top:30px solid #5eead4;border-right:0;border-bottom:0;border-left:14px solid rgba(0,0,0,0);right:100%;position:absolute}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template::after{content:"";border-top:0;border-right:0;border-bottom:30px solid rgba(0,0,0,0);border-left:14px solid #5eead4;left:100%;position:absolute}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template>i{margin-right:8px}
.eael-adv-accordion{width:auto;height:auto;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.eael-adv-accordion .eael-accordion-list .eael-accordion-header{padding:15px;border:1px solid rgba(0,0,0,.02);background-color:#f1f1f1;font-size:1rem;font-weight:600;line-height:1;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out;display:-webkit-box;display:-ms-flexbox;display:flex;-webkit-box-pack:justify;-ms-flex-pack:justify;justify-content:space-between;-webkit-box-align:center;-ms-flex-align:center;align-items:center;cursor:pointer}.eael-adv-accordion .eael-accordion-list .eael-accordion-header>.eael-accordion-tab-title{-webkit-box-flex:1;-ms-flex-positive:1;flex-grow:1;margin:0}.eael-adv-accordion .eael-accordion-list .eael-accordion-header>i,.eael-adv-accordion .eael-accordion-list .eael-accordion-header span{margin-right:10px}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .eaa-svg{font-size:32px}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .eaa-svg svg{width:1em;height:1em}.eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover{background-color:#414141}.eael-adv-accordion .eael-accordion-list .eael-accordion-header.active{background-color:#444}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle{-webkit-transform:rotate(0deg);-ms-transform:rotate(0deg);transform:rotate(0deg);z-index:10;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.eael-accordion-header .eael-advanced-accordion-icon-closed{display:block}.eael-accordion-header .eael-advanced-accordion-icon-opened{display:none}.eael-accordion-header.active .eael-advanced-accordion-icon-closed{display:none}.eael-accordion-header.active .eael-advanced-accordion-icon-opened{display:block}.eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{-webkit-transform:rotate(90deg);-ms-transform:rotate(90deg);transform:rotate(90deg);z-index:10;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.fa-accordion-icon{display:inline-block;margin-right:10px}.eael-adv-accordion .eael-accordion-list .eael-accordion-content{display:none;border:1px solid #eee;padding:15px;-webkit-box-sizing:border-box;box-sizing:border-box;font-size:1rem;line-height:1.7}.eael-adv-accordion .eael-accordion-list .eael-accordion-content.active{display:block}.rtl .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{-webkit-transform:rotate(-90deg);-ms-transform:rotate(-90deg);transform:rotate(-90deg)}
.clearfix::before,.clearfix::after{content:" ";display:table;clear:both}.eael-testimonial-slider.nav-top-left,.eael-testimonial-slider.nav-top-right,.eael-team-slider.nav-top-left,.eael-team-slider.nav-top-right,.eael-logo-carousel.nav-top-left,.eael-logo-carousel.nav-top-right,.eael-post-carousel.nav-top-left,.eael-post-carousel.nav-top-right,.eael-product-carousel.nav-top-left,.eael-product-carousel.nav-top-right{padding-top:40px}.eael-contact-form input[type=text],.eael-contact-form input[type=email],.eael-contact-form input[type=url],.eael-contact-form input[type=tel],.eael-contact-form input[type=date],.eael-contact-form input[type=number],.eael-contact-form textarea{background:#fff;box-shadow:none;-webkit-box-shadow:none;float:none;height:auto;margin:0;outline:0;width:100%}.eael-contact-form input[type=submit]{border:0;float:none;height:auto;margin:0;padding:10px 20px;width:auto;-webkit-transition:all .25s linear 0s;transition:all .25s linear 0s}.eael-contact-form.placeholder-hide input::-webkit-input-placeholder,.eael-contact-form.placeholder-hide textarea::-webkit-input-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input::-moz-placeholder,.eael-contact-form.placeholder-hide textarea::-moz-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input:-ms-input-placeholder,.eael-contact-form.placeholder-hide textarea:-ms-input-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input:-moz-placeholder,.eael-contact-form.placeholder-hide textarea:-moz-placeholder{opacity:0;visibility:hidden}.eael-custom-radio-checkbox input[type=checkbox],.eael-custom-radio-checkbox input[type=radio]{-webkit-appearance:none;-moz-appearance:none;border-style:solid;border-width:0;outline:none;min-width:1px;width:15px;height:15px;background:#ddd;padding:3px}.eael-custom-radio-checkbox input[type=checkbox]:before,.eael-custom-radio-checkbox input[type=radio]:before{content:"";width:100%;height:100%;padding:0;margin:0;display:block}.eael-custom-radio-checkbox input[type=checkbox]:checked:before,.eael-custom-radio-checkbox input[type=radio]:checked:before{background:#999;-webkit-transition:all .25s linear 0s;transition:all .25s linear 0s}.eael-custom-radio-checkbox input[type=radio]{border-radius:50%}.eael-custom-radio-checkbox input[type=radio]:before{border-radius:50%}.eael-post-elements-readmore-btn{font-size:12px;font-weight:500;-webkit-transition:all 300ms ease-in-out;transition:all 300ms ease-in-out;display:inline-block}.elementor-lightbox .dialog-widget-content{width:100%;height:100%}.eael-contact-form-align-left,.elementor-widget-eael-weform.eael-contact-form-align-left .eael-weform-container{margin:0 auto 0 0;display:inline-block;text-align:left}.eael-contact-form-align-center,.elementor-widget-eael-weform.eael-contact-form-align-center .eael-weform-container{float:none;margin:0 auto;display:inline-block;text-align:left}.eael-contact-form-align-right,.elementor-widget-eael-weform.eael-contact-form-align-right .eael-weform-container{margin:0 0 0 auto;display:inline-block;text-align:left}.eael-force-hide{display:none !important}.eael-d-none{display:none !important}.eael-d-block{display:block !important}.eael-h-auto{height:auto !important}.theme-martfury .elementor-wc-products .woocommerce ul.products li.product .product-inner .mf-rating .eael-star-rating.star-rating{display:none}.theme-martfury .elementor-wc-products .woocommerce ul.products li.product .product-inner .mf-rating .eael-star-rating.star-rating~.count{display:none}.sr-only{border:0 !important;clip:rect(1px, 1px, 1px, 1px) !important;clip-path:inset(50%) !important;height:1px !important;margin:-1px !important;overflow:hidden !important;padding:0 !important;position:absolute !important;width:1px !important;white-space:nowrap !important}.elementor-widget-eael-adv-tabs .eael-tab-content-item,.elementor-widget-eael-adv-accordion .eael-accordion-content{position:relative}.elementor-widget-eael-adv-tabs .eael-tab-content-item:hover .eael-onpage-edit-template-wrapper,.elementor-widget-eael-adv-accordion .eael-accordion-content:hover .eael-onpage-edit-template-wrapper{display:block}.eael-widget-otea-active .elementor-element:hover>.elementor-element-overlay,.eael-widget-otea-active .elementor-empty-view,.eael-widget-otea-active .elementor-add-section-inline,.eael-widget-otea-active .elementor-add-section{display:initial !important}.eael-onpage-edit-template-wrapper{position:absolute;top:0;left:0;width:100%;height:100%;display:none;border:2px solid #5eead4}.eael-onpage-edit-template-wrapper::after{position:absolute;content:"";top:0;left:0;right:0;bottom:0;z-index:2;background:#5eead4;opacity:.3}.eael-onpage-edit-template-wrapper.eael-onpage-edit-activate{display:block}.eael-onpage-edit-template-wrapper.eael-onpage-edit-activate::after{display:none}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template{background:#5eead4;color:#000;width:150px;text-align:center;height:30px;line-height:30px;font-size:12px;cursor:pointer;position:relative;z-index:3;left:50%;-webkit-transform:translateX(-50%);-ms-transform:translateX(-50%);transform:translateX(-50%)}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template::before{content:"";border-top:30px solid #5eead4;border-right:0;border-bottom:0;border-left:14px solid rgba(0,0,0,0);right:100%;position:absolute}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template::after{content:"";border-top:0;border-right:0;border-bottom:30px solid rgba(0,0,0,0);border-left:14px solid #5eead4;left:100%;position:absolute}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template>i{margin-right:8px}
.eael-adv-accordion{width:auto;height:auto;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.eael-adv-accordion .eael-accordion-list .eael-accordion-header{padding:15px;border:1px solid rgba(0,0,0,.02);background-color:#f1f1f1;font-size:1rem;font-weight:600;line-height:1;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out;display:-webkit-box;display:-ms-flexbox;display:flex;-webkit-box-pack:justify;-ms-flex-pack:justify;justify-content:space-between;-webkit-box-align:center;-ms-flex-align:center;align-items:center;cursor:pointer}.eael-adv-accordion .eael-accordion-list .eael-accordion-header>.eael-accordion-tab-title{-webkit-box-flex:1;-ms-flex-positive:1;flex-grow:1;margin:0}.eael-adv-accordion .eael-accordion-list .eael-accordion-header>i,.eael-adv-accordion .eael-accordion-list .eael-accordion-header span{margin-right:10px}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .eaa-svg{font-size:32px}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .eaa-svg svg{width:1em;height:1em}.eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover{background-color:#414141}.eael-adv-accordion .eael-accordion-list .eael-accordion-header.active{background-color:#444}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle{-webkit-transform:rotate(0deg);-ms-transform:rotate(0deg);transform:rotate(0deg);z-index:10;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.eael-accordion-header .eael-advanced-accordion-icon-closed{display:block}.eael-accordion-header .eael-advanced-accordion-icon-opened{display:none}.eael-accordion-header.active .eael-advanced-accordion-icon-closed{display:none}.eael-accordion-header.active .eael-advanced-accordion-icon-opened{display:block}.eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{-webkit-transform:rotate(90deg);-ms-transform:rotate(90deg);transform:rotate(90deg);z-index:10;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.fa-accordion-icon{display:inline-block;margin-right:10px}.eael-adv-accordion .eael-accordion-list .eael-accordion-content{display:none;border:1px solid #eee;padding:15px;-webkit-box-sizing:border-box;box-sizing:border-box;font-size:1rem;line-height:1.7}.eael-adv-accordion .eael-accordion-list .eael-accordion-content.active{display:block}.rtl .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{-webkit-transform:rotate(-90deg);-ms-transform:rotate(-90deg);transform:rotate(-90deg)}
.clearfix::before,.clearfix::after{content:" ";display:table;clear:both}.eael-testimonial-slider.nav-top-left,.eael-testimonial-slider.nav-top-right,.eael-team-slider.nav-top-left,.eael-team-slider.nav-top-right,.eael-logo-carousel.nav-top-left,.eael-logo-carousel.nav-top-right,.eael-post-carousel.nav-top-left,.eael-post-carousel.nav-top-right,.eael-product-carousel.nav-top-left,.eael-product-carousel.nav-top-right{padding-top:40px}.eael-contact-form input[type=text],.eael-contact-form input[type=email],.eael-contact-form input[type=url],.eael-contact-form input[type=tel],.eael-contact-form input[type=date],.eael-contact-form input[type=number],.eael-contact-form textarea{background:#fff;box-shadow:none;-webkit-box-shadow:none;float:none;height:auto;margin:0;outline:0;width:100%}.eael-contact-form input[type=submit]{border:0;float:none;height:auto;margin:0;padding:10px 20px;width:auto;-webkit-transition:all .25s linear 0s;transition:all .25s linear 0s}.eael-contact-form.placeholder-hide input::-webkit-input-placeholder,.eael-contact-form.placeholder-hide textarea::-webkit-input-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input::-moz-placeholder,.eael-contact-form.placeholder-hide textarea::-moz-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input:-ms-input-placeholder,.eael-contact-form.placeholder-hide textarea:-ms-input-placeholder{opacity:0;visibility:hidden}.eael-contact-form.placeholder-hide input:-moz-placeholder,.eael-contact-form.placeholder-hide textarea:-moz-placeholder{opacity:0;visibility:hidden}.eael-custom-radio-checkbox input[type=checkbox],.eael-custom-radio-checkbox input[type=radio]{-webkit-appearance:none;-moz-appearance:none;border-style:solid;border-width:0;outline:none;min-width:1px;width:15px;height:15px;background:#ddd;padding:3px}.eael-custom-radio-checkbox input[type=checkbox]:before,.eael-custom-radio-checkbox input[type=radio]:before{content:"";width:100%;height:100%;padding:0;margin:0;display:block}.eael-custom-radio-checkbox input[type=checkbox]:checked:before,.eael-custom-radio-checkbox input[type=radio]:checked:before{background:#999;-webkit-transition:all .25s linear 0s;transition:all .25s linear 0s}.eael-custom-radio-checkbox input[type=radio]{border-radius:50%}.eael-custom-radio-checkbox input[type=radio]:before{border-radius:50%}.eael-post-elements-readmore-btn{font-size:12px;font-weight:500;-webkit-transition:all 300ms ease-in-out;transition:all 300ms ease-in-out;display:inline-block}.elementor-lightbox .dialog-widget-content{width:100%;height:100%}.eael-contact-form-align-left,.elementor-widget-eael-weform.eael-contact-form-align-left .eael-weform-container{margin:0 auto 0 0;display:inline-block;text-align:left}.eael-contact-form-align-center,.elementor-widget-eael-weform.eael-contact-form-align-center .eael-weform-container{float:none;margin:0 auto;display:inline-block;text-align:left}.eael-contact-form-align-right,.elementor-widget-eael-weform.eael-contact-form-align-right .eael-weform-container{margin:0 0 0 auto;display:inline-block;text-align:left}.eael-force-hide{display:none !important}.eael-d-none{display:none !important}.eael-d-block{display:block !important}.eael-h-auto{height:auto !important}.theme-martfury .elementor-wc-products .woocommerce ul.products li.product .product-inner .mf-rating .eael-star-rating.star-rating{display:none}.theme-martfury .elementor-wc-products .woocommerce ul.products li.product .product-inner .mf-rating .eael-star-rating.star-rating~.count{display:none}.sr-only{border:0 !important;clip:rect(1px, 1px, 1px, 1px) !important;clip-path:inset(50%) !important;height:1px !important;margin:-1px !important;overflow:hidden !important;padding:0 !important;position:absolute !important;width:1px !important;white-space:nowrap !important}.elementor-widget-eael-adv-tabs .eael-tab-content-item,.elementor-widget-eael-adv-accordion .eael-accordion-content{position:relative}.elementor-widget-eael-adv-tabs .eael-tab-content-item:hover .eael-onpage-edit-template-wrapper,.elementor-widget-eael-adv-accordion .eael-accordion-content:hover .eael-onpage-edit-template-wrapper{display:block}.eael-widget-otea-active .elementor-element:hover>.elementor-element-overlay,.eael-widget-otea-active .elementor-empty-view,.eael-widget-otea-active .elementor-add-section-inline,.eael-widget-otea-active .elementor-add-section{display:initial !important}.eael-onpage-edit-template-wrapper{position:absolute;top:0;left:0;width:100%;height:100%;display:none;border:2px solid #5eead4}.eael-onpage-edit-template-wrapper::after{position:absolute;content:"";top:0;left:0;right:0;bottom:0;z-index:2;background:#5eead4;opacity:.3}.eael-onpage-edit-template-wrapper.eael-onpage-edit-activate{display:block}.eael-onpage-edit-template-wrapper.eael-onpage-edit-activate::after{display:none}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template{background:#5eead4;color:#000;width:150px;text-align:center;height:30px;line-height:30px;font-size:12px;cursor:pointer;position:relative;z-index:3;left:50%;-webkit-transform:translateX(-50%);-ms-transform:translateX(-50%);transform:translateX(-50%)}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template::before{content:"";border-top:30px solid #5eead4;border-right:0;border-bottom:0;border-left:14px solid rgba(0,0,0,0);right:100%;position:absolute}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template::after{content:"";border-top:0;border-right:0;border-bottom:30px solid rgba(0,0,0,0);border-left:14px solid #5eead4;left:100%;position:absolute}.eael-onpage-edit-template-wrapper .eael-onpage-edit-template>i{margin-right:8px}
.eael-adv-accordion{width:auto;height:auto;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.eael-adv-accordion .eael-accordion-list .eael-accordion-header{padding:15px;border:1px solid rgba(0,0,0,.02);background-color:#f1f1f1;font-size:1rem;font-weight:600;line-height:1;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out;display:-webkit-box;display:-ms-flexbox;display:flex;-webkit-box-pack:justify;-ms-flex-pack:justify;justify-content:space-between;-webkit-box-align:center;-ms-flex-align:center;align-items:center;cursor:pointer}.eael-adv-accordion .eael-accordion-list .eael-accordion-header>.eael-accordion-tab-title{-webkit-box-flex:1;-ms-flex-positive:1;flex-grow:1;margin:0}.eael-adv-accordion .eael-accordion-list .eael-accordion-header>i,.eael-adv-accordion .eael-accordion-list .eael-accordion-header span{margin-right:10px}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .eaa-svg{font-size:32px}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .eaa-svg svg{width:1em;height:1em}.eael-adv-accordion .eael-accordion-list .eael-accordion-header:hover{background-color:#414141}.eael-adv-accordion .eael-accordion-list .eael-accordion-header.active{background-color:#444}.eael-adv-accordion .eael-accordion-list .eael-accordion-header .fa-toggle{-webkit-transform:rotate(0deg);-ms-transform:rotate(0deg);transform:rotate(0deg);z-index:10;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.eael-accordion-header .eael-advanced-accordion-icon-closed{display:block}.eael-accordion-header .eael-advanced-accordion-icon-opened{display:none}.eael-accordion-header.active .eael-advanced-accordion-icon-closed{display:none}.eael-accordion-header.active .eael-advanced-accordion-icon-opened{display:block}.eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{-webkit-transform:rotate(90deg);-ms-transform:rotate(90deg);transform:rotate(90deg);z-index:10;-webkit-transition:all .3s ease-in-out;transition:all .3s ease-in-out}.fa-accordion-icon{display:inline-block;margin-right:10px}.eael-adv-accordion .eael-accordion-list .eael-accordion-content{display:none;border:1px solid #eee;padding:15px;-webkit-box-sizing:border-box;box-sizing:border-box;font-size:1rem;line-height:1.7}.eael-adv-accordion .eael-accordion-list .eael-accordion-content.active{display:block}.rtl .eael-adv-accordion .eael-accordion-list .eael-accordion-header.active .fa-toggle{-webkit-transform:rotate(-90deg);-ms-transform:rotate(-90deg);transform:rotate(-90deg)}
</style><link rel='stylesheet' id='widget-breadcrumbs-css' href='/wp-content/plugins/elementor-pro/assets/css/widget-breadcrumbs.min.css?ver=3.25.3' media='all' />
<link rel='stylesheet' id='e-motion-fx-css' href='/wp-content/plugins/elementor-pro/assets/css/modules/motion-fx.min.css?ver=3.25.3' media='all' />
<link rel='stylesheet' id='e-sticky-css' href='/wp-content/plugins/elementor-pro/assets/css/modules/sticky.min.css?ver=3.25.3' media='all' />
<link rel='stylesheet' id='rs-plugin-settings-css' href='//www.fidelitybank.ng/wp-content/plugins/revslider/sr6/assets/css/rs6.css?ver=2d932ffafb9e30b1244520214ffca261.21' media='all' />
<style id='rs-plugin-settings-inline-css'>
#rs-demo-id {}
</style>
<script src="//www.fidelitybank.ng/wp-content/plugins/revslider/sr6/assets/js/rbtools.min.js?ver=2d932ffafb9e30b1244520214ffca261.21" defer async id="tp-tools-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="//www.fidelitybank.ng/wp-content/plugins/revslider/sr6/assets/js/rs6.min.js?ver=2d932ffafb9e30b1244520214ffca261.21" defer async id="revmin-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/dearpdf-pro/assets/js/dearpdf-pro.min.js?ver=2.0.71" id="dearpdf-script-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementor-pro/assets/lib/smartmenus/jquery.smartmenus.min.js?ver=1.2.1" id="smartmenus-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementor-pro/assets/lib/sticky/jquery.sticky.min.js?ver=3.25.3" id="e-sticky-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="eael-general-js-extra" type="4364f5cca7525295a0b533ca-text/javascript">
var localize = {"ajaxurl":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php","nonce":"784563c966","i18n":{"added":"Added ","compare":"Compare","loading":"Loading..."},"eael_translate_text":{"required_text":"is a required field","invalid_text":"Invalid","billing_text":"Billing","shipping_text":"Shipping","fg_mfp_counter_text":"of"},"page_permalink":"https:\/\/www.fidelitybank.ng\/treasury-and-investment\/","cart_redirectition":"","cart_page_url":"","el_breakpoints":{"mobile":{"label":"Mobile Portrait","value":767,"default_value":767,"direction":"max","is_enabled":true},"mobile_extra":{"label":"Mobile Landscape","value":880,"default_value":880,"direction":"max","is_enabled":false},"tablet":{"label":"Tablet Portrait","value":1024,"default_value":1024,"direction":"max","is_enabled":true},"tablet_extra":{"label":"Tablet Landscape","value":1200,"default_value":1200,"direction":"max","is_enabled":false},"laptop":{"label":"Laptop","value":1366,"default_value":1366,"direction":"max","is_enabled":false},"widescreen":{"label":"Widescreen","value":2400,"default_value":2400,"direction":"min","is_enabled":false}},"ParticleThemesData":{"default":"{\"particles\":{\"number\":{\"value\":160,\"density\":{\"enable\":true,\"value_area\":800}},\"color\":{\"value\":\"#ffffff\"},\"shape\":{\"type\":\"circle\",\"stroke\":{\"width\":0,\"color\":\"#000000\"},\"polygon\":{\"nb_sides\":5},\"image\":{\"src\":\"img\/github.svg\",\"width\":100,\"height\":100}},\"opacity\":{\"value\":0.5,\"random\":false,\"anim\":{\"enable\":false,\"speed\":1,\"opacity_min\":0.1,\"sync\":false}},\"size\":{\"value\":3,\"random\":true,\"anim\":{\"enable\":false,\"speed\":40,\"size_min\":0.1,\"sync\":false}},\"line_linked\":{\"enable\":true,\"distance\":150,\"color\":\"#ffffff\",\"opacity\":0.4,\"width\":1},\"move\":{\"enable\":true,\"speed\":6,\"direction\":\"none\",\"random\":false,\"straight\":false,\"out_mode\":\"out\",\"bounce\":false,\"attract\":{\"enable\":false,\"rotateX\":600,\"rotateY\":1200}}},\"interactivity\":{\"detect_on\":\"canvas\",\"events\":{\"onhover\":{\"enable\":true,\"mode\":\"repulse\"},\"onclick\":{\"enable\":true,\"mode\":\"push\"},\"resize\":true},\"modes\":{\"grab\":{\"distance\":400,\"line_linked\":{\"opacity\":1}},\"bubble\":{\"distance\":400,\"size\":40,\"duration\":2,\"opacity\":8,\"speed\":3},\"repulse\":{\"distance\":200,\"duration\":0.4},\"push\":{\"particles_nb\":4},\"remove\":{\"particles_nb\":2}}},\"retina_detect\":true}","nasa":"{\"particles\":{\"number\":{\"value\":250,\"density\":{\"enable\":true,\"value_area\":800}},\"color\":{\"value\":\"#ffffff\"},\"shape\":{\"type\":\"circle\",\"stroke\":{\"width\":0,\"color\":\"#000000\"},\"polygon\":{\"nb_sides\":5},\"image\":{\"src\":\"img\/github.svg\",\"width\":100,\"height\":100}},\"opacity\":{\"value\":1,\"random\":true,\"anim\":{\"enable\":true,\"speed\":1,\"opacity_min\":0,\"sync\":false}},\"size\":{\"value\":3,\"random\":true,\"anim\":{\"enable\":false,\"speed\":4,\"size_min\":0.3,\"sync\":false}},\"line_linked\":{\"enable\":false,\"distance\":150,\"color\":\"#ffffff\",\"opacity\":0.4,\"width\":1},\"move\":{\"enable\":true,\"speed\":1,\"direction\":\"none\",\"random\":true,\"straight\":false,\"out_mode\":\"out\",\"bounce\":false,\"attract\":{\"enable\":false,\"rotateX\":600,\"rotateY\":600}}},\"interactivity\":{\"detect_on\":\"canvas\",\"events\":{\"onhover\":{\"enable\":true,\"mode\":\"bubble\"},\"onclick\":{\"enable\":true,\"mode\":\"repulse\"},\"resize\":true},\"modes\":{\"grab\":{\"distance\":400,\"line_linked\":{\"opacity\":1}},\"bubble\":{\"distance\":250,\"size\":0,\"duration\":2,\"opacity\":0,\"speed\":3},\"repulse\":{\"distance\":400,\"duration\":0.4},\"push\":{\"particles_nb\":4},\"remove\":{\"particles_nb\":2}}},\"retina_detect\":true}","bubble":"{\"particles\":{\"number\":{\"value\":15,\"density\":{\"enable\":true,\"value_area\":800}},\"color\":{\"value\":\"#1b1e34\"},\"shape\":{\"type\":\"polygon\",\"stroke\":{\"width\":0,\"color\":\"#000\"},\"polygon\":{\"nb_sides\":6},\"image\":{\"src\":\"img\/github.svg\",\"width\":100,\"height\":100}},\"opacity\":{\"value\":0.3,\"random\":true,\"anim\":{\"enable\":false,\"speed\":1,\"opacity_min\":0.1,\"sync\":false}},\"size\":{\"value\":50,\"random\":false,\"anim\":{\"enable\":true,\"speed\":10,\"size_min\":40,\"sync\":false}},\"line_linked\":{\"enable\":false,\"distance\":200,\"color\":\"#ffffff\",\"opacity\":1,\"width\":2},\"move\":{\"enable\":true,\"speed\":8,\"direction\":\"none\",\"random\":false,\"straight\":false,\"out_mode\":\"out\",\"bounce\":false,\"attract\":{\"enable\":false,\"rotateX\":600,\"rotateY\":1200}}},\"interactivity\":{\"detect_on\":\"canvas\",\"events\":{\"onhover\":{\"enable\":false,\"mode\":\"grab\"},\"onclick\":{\"enable\":false,\"mode\":\"push\"},\"resize\":true},\"modes\":{\"grab\":{\"distance\":400,\"line_linked\":{\"opacity\":1}},\"bubble\":{\"distance\":400,\"size\":40,\"duration\":2,\"opacity\":8,\"speed\":3},\"repulse\":{\"distance\":200,\"duration\":0.4},\"push\":{\"particles_nb\":4},\"remove\":{\"particles_nb\":2}}},\"retina_detect\":true}","snow":"{\"particles\":{\"number\":{\"value\":450,\"density\":{\"enable\":true,\"value_area\":800}},\"color\":{\"value\":\"#fff\"},\"shape\":{\"type\":\"circle\",\"stroke\":{\"width\":0,\"color\":\"#000000\"},\"polygon\":{\"nb_sides\":5},\"image\":{\"src\":\"img\/github.svg\",\"width\":100,\"height\":100}},\"opacity\":{\"value\":0.5,\"random\":true,\"anim\":{\"enable\":false,\"speed\":1,\"opacity_min\":0.1,\"sync\":false}},\"size\":{\"value\":5,\"random\":true,\"anim\":{\"enable\":false,\"speed\":40,\"size_min\":0.1,\"sync\":false}},\"line_linked\":{\"enable\":false,\"distance\":500,\"color\":\"#ffffff\",\"opacity\":0.4,\"width\":2},\"move\":{\"enable\":true,\"speed\":6,\"direction\":\"bottom\",\"random\":false,\"straight\":false,\"out_mode\":\"out\",\"bounce\":false,\"attract\":{\"enable\":false,\"rotateX\":600,\"rotateY\":1200}}},\"interactivity\":{\"detect_on\":\"canvas\",\"events\":{\"onhover\":{\"enable\":true,\"mode\":\"bubble\"},\"onclick\":{\"enable\":true,\"mode\":\"repulse\"},\"resize\":true},\"modes\":{\"grab\":{\"distance\":400,\"line_linked\":{\"opacity\":0.5}},\"bubble\":{\"distance\":400,\"size\":4,\"duration\":0.3,\"opacity\":1,\"speed\":3},\"repulse\":{\"distance\":200,\"duration\":0.4},\"push\":{\"particles_nb\":4},\"remove\":{\"particles_nb\":2}}},\"retina_detect\":true}","nyan_cat":"{\"particles\":{\"number\":{\"value\":150,\"density\":{\"enable\":false,\"value_area\":800}},\"color\":{\"value\":\"#ffffff\"},\"shape\":{\"type\":\"star\",\"stroke\":{\"width\":0,\"color\":\"#000000\"},\"polygon\":{\"nb_sides\":5},\"image\":{\"src\":\"http:\/\/wiki.lexisnexis.com\/academic\/images\/f\/fb\/Itunes_podcast_icon_300.jpg\",\"width\":100,\"height\":100}},\"opacity\":{\"value\":0.5,\"random\":false,\"anim\":{\"enable\":false,\"speed\":1,\"opacity_min\":0.1,\"sync\":false}},\"size\":{\"value\":4,\"random\":true,\"anim\":{\"enable\":false,\"speed\":40,\"size_min\":0.1,\"sync\":false}},\"line_linked\":{\"enable\":false,\"distance\":150,\"color\":\"#ffffff\",\"opacity\":0.4,\"width\":1},\"move\":{\"enable\":true,\"speed\":14,\"direction\":\"left\",\"random\":false,\"straight\":true,\"out_mode\":\"out\",\"bounce\":false,\"attract\":{\"enable\":false,\"rotateX\":600,\"rotateY\":1200}}},\"interactivity\":{\"detect_on\":\"canvas\",\"events\":{\"onhover\":{\"enable\":false,\"mode\":\"grab\"},\"onclick\":{\"enable\":true,\"mode\":\"repulse\"},\"resize\":true},\"modes\":{\"grab\":{\"distance\":200,\"line_linked\":{\"opacity\":1}},\"bubble\":{\"distance\":400,\"size\":40,\"duration\":2,\"opacity\":8,\"speed\":3},\"repulse\":{\"distance\":200,\"duration\":0.4},\"push\":{\"particles_nb\":4},\"remove\":{\"particles_nb\":2}}},\"retina_detect\":true}"},"eael_login_nonce":"2c48847120","eael_register_nonce":"be521d89d3","eael_lostpassword_nonce":"0741eccc36","eael_resetpassword_nonce":"38ff71c77d"};
</script>
<script src="/wp-content/plugins/essential-addons-for-elementor-lite/assets/front-end/js/view/general.min.js?ver=6.0.10" id="eael-general-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/uploads/essential-addons-elementor/eael-15256.js?ver=1689851247" id="eael-15256-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementskit-lite/libs/framework/assets/js/frontend-script.js?ver=3.3.2" id="elementskit-framework-js-frontend-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="elementskit-framework-js-frontend-js-after" type="4364f5cca7525295a0b533ca-text/javascript">
		var elementskit = {
			resturl: 'https://www.fidelitybank.ng/wp-json/elementskit/v1/',
		}

		
</script>
<script src="/wp-content/plugins/elementskit-lite/widgets/init/assets/js/widget-scripts.js?ver=3.3.2" id="ekit-widget-scripts-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/wordpress-store-locator/public/vendor/bootstrap/bootstrap.min.js?ver=4.5.3" id="bootstrap-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="bdt-uikit-js-extra" type="4364f5cca7525295a0b533ca-text/javascript">
var element_pack_ajax_login_config = {"ajaxurl":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php","language":"en","loadingmessage":"Sending user info, please wait...","unknownerror":"Unknown error, make sure access is correct!"};
var ElementPackConfig = {"ajaxurl":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php","nonce":"88f4350e6d","data_table":{"language":{"sLengthMenu":"Show _MENU_ Entries","sInfo":"Showing _START_ to _END_ of _TOTAL_ entries","sSearch":"Search :","sZeroRecords":"No matching records found","oPaginate":{"sPrevious":"Previous","sNext":"Next"}}},"contact_form":{"sending_msg":"Sending message please wait...","captcha_nd":"Invisible captcha not defined!","captcha_nr":"Could not get invisible captcha response!"},"mailchimp":{"subscribing":"Subscribing you please wait..."},"search":{"more_result":"More Results","search_result":"SEARCH RESULT","not_found":"not found"},"words_limit":{"read_more":"[read more]","read_less":"[read less]"},"elements_data":{"sections":[],"columns":[],"widgets":[]}};
</script>
<script src="/wp-content/plugins/bdthemes-element-pack/assets/js/bdt-uikit.min.js?ver=3.21.7" id="bdt-uikit-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/bdthemes-element-pack/assets/js/common/helper.min.js?ver=7.18.7" id="element-pack-helper-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="wpsr_main_js-js-extra" type="4364f5cca7525295a0b533ca-text/javascript">
var wp_socializer = {"ajax_url":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php"};
</script>
<script src="/wp-content/plugins/wp-socializer/public/js/wp-socializer.min.js?ver=7.8" id="wpsr_main_js-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementor-pro/assets/js/webpack-pro.runtime.min.js?ver=3.25.3" id="elementor-pro-webpack-runtime-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementor/assets/js/webpack.runtime.min.js?ver=3.25.8" id="elementor-webpack-runtime-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementor/assets/js/frontend-modules.min.js?ver=3.25.8" id="elementor-frontend-modules-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="https://www.fidelitybank.ng/wp-includes/js/dist/hooks.min.js?ver=4d63a3d491d11ffd8ac6" id="wp-hooks-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="https://www.fidelitybank.ng/wp-includes/js/dist/i18n.min.js?ver=5e580eb46a90c2b997e6" id="wp-i18n-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="wp-i18n-js-after" type="4364f5cca7525295a0b533ca-text/javascript">
wp.i18n.setLocaleData( { 'text direction\u0004ltr': [ 'ltr' ] } );
</script>
<script id="elementor-pro-frontend-js-before" type="4364f5cca7525295a0b533ca-text/javascript">
var ElementorProFrontendConfig = {"ajaxurl":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php","nonce":"e26deeb95a","urls":{"assets":"\/wp-content\/plugins\/elementor-pro\/assets\/","rest":"https:\/\/www.fidelitybank.ng\/wp-json\/"},"settings":{"lazy_load_background_images":true},"popup":{"hasPopUps":true},"shareButtonsNetworks":{"facebook":{"title":"Facebook","has_counter":true},"twitter":{"title":"Twitter"},"linkedin":{"title":"LinkedIn","has_counter":true},"pinterest":{"title":"Pinterest","has_counter":true},"reddit":{"title":"Reddit","has_counter":true},"vk":{"title":"VK","has_counter":true},"odnoklassniki":{"title":"OK","has_counter":true},"tumblr":{"title":"Tumblr"},"digg":{"title":"Digg"},"skype":{"title":"Skype"},"stumbleupon":{"title":"StumbleUpon","has_counter":true},"mix":{"title":"Mix"},"telegram":{"title":"Telegram"},"pocket":{"title":"Pocket","has_counter":true},"xing":{"title":"XING","has_counter":true},"whatsapp":{"title":"WhatsApp"},"email":{"title":"Email"},"print":{"title":"Print"},"x-twitter":{"title":"X"},"threads":{"title":"Threads"}},"facebook_sdk":{"lang":"en_US","app_id":""},"lottie":{"defaultAnimationUrl":"\/wp-content\/plugins\/elementor-pro\/modules\/lottie\/assets\/animations\/default.json"}};
</script>
<script src="/wp-content/plugins/elementor-pro/assets/js/frontend.min.js?ver=3.25.3" id="elementor-pro-frontend-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="https://www.fidelitybank.ng/wp-includes/js/jquery/ui/core.min.js?ver=1.13.3" id="jquery-ui-core-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="elementor-frontend-js-before" type="4364f5cca7525295a0b533ca-text/javascript">
var elementorFrontendConfig = {"environmentMode":{"edit":false,"wpPreview":false,"isScriptDebug":false},"i18n":{"shareOnFacebook":"Share on Facebook","shareOnTwitter":"Share on Twitter","pinIt":"Pin it","download":"Download","downloadImage":"Download image","fullscreen":"Fullscreen","zoom":"Zoom","share":"Share","playVideo":"Play Video","previous":"Previous","next":"Next","close":"Close","a11yCarouselWrapperAriaLabel":"Carousel | Horizontal scrolling: Arrow Left & Right","a11yCarouselPrevSlideMessage":"Previous slide","a11yCarouselNextSlideMessage":"Next slide","a11yCarouselFirstSlideMessage":"This is the first slide","a11yCarouselLastSlideMessage":"This is the last slide","a11yCarouselPaginationBulletMessage":"Go to slide"},"is_rtl":false,"breakpoints":{"xs":0,"sm":480,"md":768,"lg":1025,"xl":1440,"xxl":1600},"responsive":{"breakpoints":{"mobile":{"label":"Mobile Portrait","value":767,"default_value":767,"direction":"max","is_enabled":true},"mobile_extra":{"label":"Mobile Landscape","value":880,"default_value":880,"direction":"max","is_enabled":false},"tablet":{"label":"Tablet Portrait","value":1024,"default_value":1024,"direction":"max","is_enabled":true},"tablet_extra":{"label":"Tablet Landscape","value":1200,"default_value":1200,"direction":"max","is_enabled":false},"laptop":{"label":"Laptop","value":1366,"default_value":1366,"direction":"max","is_enabled":false},"widescreen":{"label":"Widescreen","value":2400,"default_value":2400,"direction":"min","is_enabled":false}},"hasCustomBreakpoints":false},"version":"3.25.8","is_static":false,"experimentalFeatures":{"additional_custom_breakpoints":true,"container":true,"e_swiper_latest":true,"e_nested_atomic_repeaters":true,"e_optimized_control_loading":true,"e_onboarding":true,"e_css_smooth_scroll":true,"theme_builder_v2":true,"home_screen":true,"landing-pages":true,"nested-elements":true,"editor_v2":true,"link-in-bio":true,"floating-buttons":true},"urls":{"assets":"\/wp-content\/plugins\/elementor\/assets\/","ajaxurl":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php","uploadUrl":"\/wp-content\/uploads"},"nonces":{"floatingButtonsClickTracking":"ba59c4e327"},"swiperClass":"swiper","settings":{"page":{"element_pack_global_tooltip_width":{"unit":"px","size":"","sizes":[]},"element_pack_global_tooltip_width_tablet":{"unit":"px","size":"","sizes":[]},"element_pack_global_tooltip_width_mobile":{"unit":"px","size":"","sizes":[]},"element_pack_global_tooltip_padding":{"unit":"px","top":"","right":"","bottom":"","left":"","isLinked":true},"element_pack_global_tooltip_padding_tablet":{"unit":"px","top":"","right":"","bottom":"","left":"","isLinked":true},"element_pack_global_tooltip_padding_mobile":{"unit":"px","top":"","right":"","bottom":"","left":"","isLinked":true},"element_pack_global_tooltip_border_radius":{"unit":"px","top":"","right":"","bottom":"","left":"","isLinked":true},"element_pack_global_tooltip_border_radius_tablet":{"unit":"px","top":"","right":"","bottom":"","left":"","isLinked":true},"element_pack_global_tooltip_border_radius_mobile":{"unit":"px","top":"","right":"","bottom":"","left":"","isLinked":true}},"editorPreferences":[]},"kit":{"active_breakpoints":["viewport_mobile","viewport_tablet"],"global_image_lightbox":"yes","lightbox_enable_counter":"yes","lightbox_enable_fullscreen":"yes","lightbox_enable_zoom":"yes","lightbox_enable_share":"yes","lightbox_title_src":"title","lightbox_description_src":"description"},"post":{"id":15256,"title":"Treasury%20and%20Investment%20-%20Fidelity%20Bank%20Plc%20%7C%20We%20are%20Fidelity","excerpt":"","featuredImage":false}};
</script>
<script src="/wp-content/plugins/elementor/assets/js/frontend.min.js?ver=3.25.8" id="elementor-frontend-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementor-pro/assets/js/elements-handlers.min.js?ver=3.25.3" id="pro-elements-handlers-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/jet-elements/assets/js/lib/waypoints/waypoints.js?ver=4.0.2" id="waypoints-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="jet-elements-js-extra" type="4364f5cca7525295a0b533ca-text/javascript">
var jetElements = {"ajaxUrl":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php","isMobile":"false","templateApiUrl":"https:\/\/www.fidelitybank.ng\/wp-json\/jet-elements-api\/v1\/elementor-template","devMode":"false","messages":{"invalidMail":"Please specify a valid e-mail"}};
</script>
<script src="/wp-content/plugins/jet-elements/assets/js/jet-elements.min.js?ver=2.7.1.1" id="jet-elements-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script src="/wp-content/plugins/elementskit-lite/widgets/init/assets/js/animate-circle.min.js?ver=3.3.2" id="animate-circle-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>
<script id="elementskit-elementor-js-extra" type="4364f5cca7525295a0b533ca-text/javascript">
var ekit_config = {"ajaxurl":"https:\/\/www.fidelitybank.ng\/wp-admin\/admin-ajax.php","nonce":"450eb1d03f"};
</script>
<script src="/wp-content/plugins/elementskit-lite/widgets/init/assets/js/elementor.js?ver=3.3.2" id="elementskit-elementor-js" type="4364f5cca7525295a0b533ca-text/javascript"></script>

<script src="/cdn-cgi/scripts/7d0fa10a/cloudflare-static/rocket-loader.min.js" data-cf-settings="4364f5cca7525295a0b533ca-|49" defer></script><script defer src="https://static.cloudflareinsights.com/beacon.min.js/vcd15cbe7772f49c399c6a5babf22c1241717689176015" integrity="sha512-ZpsOmlRQV6y907TI0dKBHq9Md29nnaEIPlkf84rnaERnq6zvWvPUqr2ft8M1aS28oN72PdrCzSjY4U6VaAw1EQ==" data-cf-beacon='{"rayId":"8e8d3322db07934c","serverTiming":{"name":{"cfExtPri":true,"cfL4":true,"cfSpeedBrain":true,"cfCacheStatus":true}},"version":"2024.10.5","token":"e97d52a00d014fc4bb0f4c25cb8188f1"}' crossorigin="anonymous"></script>
</body>
</html>
