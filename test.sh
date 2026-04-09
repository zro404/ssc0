indent() {
    sed 's/^/  /'
}

echo "Running Test Suite"
mit-scheme -quiet --load tests/runner.scm --eval "(exit)" | indent

