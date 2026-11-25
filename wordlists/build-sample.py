#!/usr/bin/env python3
"""Generates wordlists/common-passwords.txt: a representative sample of
very common / weak passwords, for fast live-demo cracking.

This is NOT rockyou.txt (14M lines, too slow to carry around and overkill
for a 2h session). If you want the real rockyou.txt for a more realistic
demo, drop it at wordlists/rockyou.txt and point the scripts at it instead
(see scripts/crack-offline.sh).
"""

bases = [
    "password", "contraseña", "admin", "welcome", "letmein", "qwerty",
    "iloveyou", "monkey", "dragon", "football", "baseball", "master",
    "shadow", "superman", "trustno1", "princess", "sunshine", "flower",
    "summer", "winter", "autumn", "spring", "freedom", "liberty",
]

suffixes = ["", "1", "12", "123", "1234", "123456", "!", "007", "01"]
years = ["2023", "2024", "2025", "2026"]


def variants(word: str):
    yield word
    yield word.capitalize()
    yield word.upper()


def main():
    seen = set()
    lines = []

    # plain common passwords, several cases, with simple suffixes
    for base in bases:
        for form in variants(base):
            for suf in suffixes:
                candidate = f"{form}{suf}"
                if candidate not in seen:
                    seen.add(candidate)
                    lines.append(candidate)

    # "word + year + !" pattern, the one the OSINT demo targets
    for base in bases:
        for form in variants(base):
            for year in years:
                for bang in ("", "!"):
                    candidate = f"{form}{year}{bang}"
                    if candidate not in seen:
                        seen.add(candidate)
                        lines.append(candidate)

    # a handful of classic literal weak passwords, verbatim
    literal = [
        "1234", "123456", "123456789", "12345678", "1234567", "qwerty123",
        "abc123", "password1", "Password1", "Password1!", "changeme",
        "letmein1", "admin123", "root", "toor", "guest", "test123",
    ]
    for candidate in literal:
        if candidate not in seen:
            seen.add(candidate)
            lines.append(candidate)

    with open("common-passwords.txt", "w") as f:
        f.write("\n".join(lines) + "\n")

    print(f"wrote {len(lines)} candidates to common-passwords.txt")


if __name__ == "__main__":
    main()
