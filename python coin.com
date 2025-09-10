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
    main()

