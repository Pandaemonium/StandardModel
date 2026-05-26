"""Explore the sedenion zero-divisor finite geometry.

This script is intentionally small and deterministic.  It fixes the
recursive Cayley-Dickson convention documented in
Sedenions/CayleyDickson_Convention.md and computes the first invariants that
the research program needs.

It is an oracle/exploration script, not a proof.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations, product


def conj_sign(n: int, a: int) -> int:
    """Conjugation sign for basis label a in dimension 2^n."""
    if a == 0:
        return 1
    return -1


def cd_mul_basis(n: int, a: int, b: int) -> tuple[int, int]:
    """Return (sign, index) for e_a * e_b in the 2^n Cayley-Dickson algebra."""
    if n == 0:
        return (1, 0)

    half = 1 << (n - 1)
    ah, al = divmod(a, half)
    bh, bl = divmod(b, half)

    if ah == 0 and bh == 0:
        s, k = cd_mul_basis(n - 1, al, bl)
        return (s, k)

    if ah == 0 and bh == 1:
        # (e_al, 0) * (0, e_bl) = (0, e_bl * e_al)
        s, k = cd_mul_basis(n - 1, bl, al)
        return (s, half + k)

    if ah == 1 and bh == 0:
        # (0, e_al) * (e_bl, 0) = (0, e_al * conjugate(e_bl))
        s, k = cd_mul_basis(n - 1, al, bl)
        return (s * conj_sign(n - 1, bl), half + k)

    # (0, e_al) * (0, e_bl) = (-conjugate(e_bl) * e_al, 0)
    s, k = cd_mul_basis(n - 1, bl, al)
    return (-conj_sign(n - 1, bl) * s, k)


OCTONION_REFERENCE = [
    (0b001, 0b010, 0b011),
    (0b001, 0b100, 0b101),
    (0b001, 0b111, 0b110),
    (0b010, 0b100, 0b110),
    (0b010, 0b101, 0b111),
    (0b011, 0b100, 0b111),
    (0b011, 0b110, 0b101),
]


def hamming_parity_ok(flips: tuple[int, ...]) -> bool:
    b1, b2, b3, b4, b5, b6, b7 = flips
    return (
        (b4 ^ b5 ^ b6 ^ b7) == 0
        and (b2 ^ b3 ^ b6 ^ b7) == 0
        and (b1 ^ b3 ^ b5 ^ b7) == 0
    )


def fano_flip_patterns_from_sign_changes() -> set[tuple[int, ...]]:
    """Flip patterns obtained by changing signs of the seven imaginary units."""
    patterns: set[tuple[int, ...]] = set()
    for eps_bits in product([0, 1], repeat=7):
        # eps_bits[i-1] = 1 means e_i is negated.
        flips = []
        for a, b, c in OCTONION_REFERENCE:
            flips.append(eps_bits[a - 1] ^ eps_bits[b - 1] ^ eps_bits[c - 1])
        patterns.add(tuple(flips))
    return patterns


def assessor_pairs() -> list[tuple[int, int]]:
    """The 42 mixed low/high assessor supports ((0,i),(1,j))."""
    pairs = []
    for i in range(1, 8):
        for j in range(1, 8):
            if i != j:
                pairs.append((i, 8 + j))
    return pairs


def vec_mul(x: dict[int, int], y: dict[int, int]) -> dict[int, int]:
    """Multiply sparse integer linear combinations in the sedenion basis."""
    out: Counter[int] = Counter()
    for a, ca in x.items():
        for b, cb in y.items():
            s, k = cd_mul_basis(4, a, b)
            out[k] += ca * cb * s
    return {k: v for k, v in out.items() if v}


def signed_assessor_vectors() -> list[tuple[tuple[int, int], int, dict[int, int]]]:
    """Return e_low + sigma e_high for each assessor and sigma in {+1,-1}."""
    out = []
    for low, high in assessor_pairs():
        for sigma in [1, -1]:
            out.append(((low, high), sigma, {low: 1, high: sigma}))
    return out


def zero_product_pairs() -> list[tuple[tuple[int, int], int, tuple[int, int], int]]:
    """Find signed assessor vectors whose product is zero."""
    vectors = signed_assessor_vectors()
    zeros = []
    for (a_pair, a_sig, a_vec), (b_pair, b_sig, b_vec) in product(vectors, repeat=2):
        if a_pair == b_pair:
            continue
        if vec_mul(a_vec, b_vec) == {}:
            zeros.append((a_pair, a_sig, b_pair, b_sig))
    return zeros


def zero_product_supports() -> set[frozenset[int]]:
    """Distinct four-point supports occurring in signed assessor zero products."""
    return {
        frozenset([a[0], a[1], b[0], b[1]])
        for a, _sa, b, _sb in zero_product_pairs()
    }


def seed_plane_supports() -> set[frozenset[int]]:
    """All same-strut mixed affine-plane supports.

    The bare same-strut condition produces 63 supports.  The signed
    Cayley-Dickson zero-product equations select 42 of them; see
    zero_product_supports.
    """
    supports: set[frozenset[int]] = set()
    for i, j in product(range(1, 8), repeat=2):
        if i == j:
            continue
        s = i ^ j
        for p, q in product(range(1, 8), repeat=2):
            if p == q:
                continue
            if (p, q) == (i, j):
                continue
            if (p ^ q) == s:
                supports.add(frozenset([i, 8 + j, p, 8 + q]))
    return supports


def rank_binary(rows: list[int], ncols: int = 16) -> int:
    rows = rows[:]
    rank = 0
    for col in range(ncols):
        pivot = None
        for r in range(rank, len(rows)):
            if (rows[r] >> col) & 1:
                pivot = r
                break
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        for r in range(len(rows)):
            if r != rank and ((rows[r] >> col) & 1):
                rows[r] ^= rows[rank]
        rank += 1
    return rank


def span_binary(rows: list[int]) -> set[int]:
    code = {0}
    for row in rows:
        code |= {word ^ row for word in list(code)}
    return code


def weight(word: int) -> int:
    return word.bit_count()


def support_word(support: frozenset[int]) -> int:
    out = 0
    for i in support:
        out |= 1 << i
    return out


def rm24_code() -> set[int]:
    """Evaluate all degree <= 2 Boolean polynomials on F_2^4."""
    words = set()
    points = list(range(16))
    linear_masks = list(range(16))
    quad_pairs = list(combinations(range(4), 2))
    for const in [0, 1]:
        for lin in linear_masks:
            for quad_coeffs in product([0, 1], repeat=len(quad_pairs)):
                word = 0
                for x in points:
                    val = const
                    for i in range(4):
                        val ^= ((lin >> i) & 1) & ((x >> i) & 1)
                    for coeff, (i, j) in zip(quad_coeffs, quad_pairs):
                        val ^= coeff & ((x >> i) & 1) & ((x >> j) & 1)
                    if val:
                        word |= 1 << x
                words.add(word)
    return words


def shortened_rm24() -> set[int]:
    """The subcode of RM(2,4) with coordinates 0 and 8 forced to zero."""
    return {w for w in rm24_code() if ((w >> 0) & 1) == 0 and ((w >> 8) & 1) == 0}


def summarize_span(name: str, supports: set[frozenset[int]]) -> None:
    words = [support_word(s) for s in sorted(supports, key=lambda x: sorted(x))]
    code = span_binary(words)
    shortened = shortened_rm24()
    print(f"{name} supports: {len(supports)}")
    print(f"{name} span rank: {rank_binary(words)}")
    print(f"{name} span size: {len(code)}")
    print(f"{name} span equals shortened RM(2,4): {code == shortened}")
    print(f"{name} weight enumerator:", dict(sorted(Counter(weight(w) for w in code).items())))


def main() -> None:
    print("Octonion reference products:")
    for a, b, c in OCTONION_REFERENCE:
        print(f"  {a:03b} * {b:03b} =", cd_mul_basis(3, a, b), f"expected +{c:03b}")

    patterns = fano_flip_patterns_from_sign_changes()
    print(f"\nFano sign-change flip patterns: {len(patterns)}")
    print(f"All satisfy Hamming parity checks: {all(hamming_parity_ok(p) for p in patterns)}")

    zeros = zero_product_pairs()
    unordered_supports = zero_product_supports()
    print(f"\nSigned zero-product ordered pairs: {len(zeros)}")
    print(f"Distinct four-point supports from zero products: {len(unordered_supports)}")

    same_strut = seed_plane_supports()
    print(f"All same-strut mixed affine supports: {len(same_strut)}")
    print(f"Zero-product supports are a subset: {unordered_supports <= same_strut}")
    print(f"Extra same-strut supports not selected by signs: {len(same_strut - unordered_supports)}")
    print(f"Shortened RM(2,4) size: {len(shortened_rm24())}")
    print()
    summarize_span("Zero-product", unordered_supports)
    print()
    summarize_span("Same-strut", same_strut)


if __name__ == "__main__":
    main()
