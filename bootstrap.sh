echo "Bootstrapping ssc0"

mkdir -p build

mit-scheme -quiet --load src/main.scm --eval "(compile-file \"src/main.scm\")" --eval "(exit)"

find src/ -type f -name "*.asm" -exec mv {} build/ \;
