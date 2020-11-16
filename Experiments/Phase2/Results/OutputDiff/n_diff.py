import sys


def main():
    MAX_LINES = 512

    if len(sys.argv) != 3:
        print("Incorrect usage. Provide the name of 2 files to compare.")
        sys.exit(1)
    else:
        file1 = sys.argv[1]
        file2 = sys.argv[2]

    count = 0

    f1 = open(file1, 'r')
    f2 = open(file2, 'r')

    for i in range(MAX_LINES):
        line1 = f1.readline()
        line2 = f2.readline()
        if line1 == line2:
            count += 1

    f1.close()
    f2.close()

    print(f"Number of equal lines: {count}/{MAX_LINES}")


if __name__ == "__main__":
    main()
