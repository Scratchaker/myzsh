# Custom editor
for i in micro nvim nano vim vi; do
    command -v "$i" >/dev/null 2>&1 && export EDITOR="$i" VISUAL="$i" && break
done
