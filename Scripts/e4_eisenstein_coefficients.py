"""
Compute the first 100 coefficients of the E4 Eisenstein series.

E4(q) = 1 + 240 * sum_{n=1}^{inf} sigma_3(n) * q^n

where sigma_3(n) = sum of cubes of divisors of n.

The coefficient of q^n for n >= 1 is 240 * sigma_3(n).
The coefficient of q^0 is 1.

Output: e4_coefficients.csv with columns (n, sigma3_n, e4_coeff_n).
"""

import csv


def sigma3(n: int) -> int:
    """Return sigma_3(n) = sum of cubes of all positive divisors of n."""
    return sum(d ** 3 for d in range(1, n + 1) if n % d == 0)


def e4_coeff(n: int) -> int:
    """Return the n-th Fourier coefficient of E4(q).

    E4(q) = sum_{n=0}^{inf} a(n) * q^n
    a(0) = 1
    a(n) = 240 * sigma_3(n)  for n >= 1
    """
    if n == 0:
        return 1
    return 240 * sigma3(n)


def main():
    output_path = "Scripts/e4_coefficients.csv"
    num_terms = 1000

    rows = []
    for n in range(num_terms + 1):
        s3 = sigma3(n) if n >= 1 else None
        coeff = e4_coeff(n)
        rows.append((n, s3, coeff))

    with open(output_path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["n", "sigma3_n", "e4_coeff_n"])
        for n, s3, coeff in rows:
            writer.writerow([n, "" if s3 is None else s3, coeff])

    print(f"Wrote {len(rows)} rows to {output_path}")
    print()
    print("First 10 rows:")
    print(f"{'n':>4}  {'sigma3(n)':>14}  {'e4_coeff(n)':>14}")
    print("-" * 36)
    for n, s3, coeff in rows[:10]:
        s3_str = "" if s3 is None else str(s3)
        print(f"{n:>4}  {s3_str:>14}  {coeff:>14}")

    # Spot-check against known values from the Lean formalization:
    # sigma3(1) = 1,  e4[1] = 240
    # sigma3(2) = 9,  e4[2] = 2160
    # sigma3(3) = 28, e4[3] = 6720
    # sigma3(4) = 73, e4[4] = 17520
    # sigma3(5) = 126, e4[5] = 30240
    # sigma3(6) = 252, e4[6] = 60480
    known = {1: 240, 2: 2160, 3: 6720, 4: 17520, 5: 30240, 6: 60480}
    print()
    print("Spot-check against Lean-verified values:")
    all_ok = True
    for n, expected in sorted(known.items()):
        got = rows[n][2]
        status = "OK" if got == expected else f"MISMATCH (expected {expected})"
        print(f"  e4[{n}] = {got}  {status}")
        if got != expected:
            all_ok = False
    print("All spot checks passed." if all_ok else "SPOT CHECK FAILURES.")


if __name__ == "__main__":
    main()
