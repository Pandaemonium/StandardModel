#!/usr/bin/env python3
"""K1-STEP0 root-hygiene probe for the KP fixed-forest count.

This is an oracle/debugging script, not trusted Lean.  It tests the small
one-block case behind the run's off-by-root warning.

Conclusion:
- If an encoder pins the root-child slot inside each child block before emitting
  a word, then full total-block permutations collapse; only permutations of the
  non-pinned free slots are visible.
- If the codomain is strengthened to structured data that preserves the whole
  ordered block, full total-block permutations are visible.

Thus `m_j!` is compatible with a structured-partition route, but not with a
word encoder that canonicalizes/pins the root-child inside the block.
"""

from __future__ import annotations

from itertools import permutations


def pinned_word(root: int, root_child: int, block: tuple[int, ...]) -> tuple[int, ...]:
    """Root-first word with the root-child canonically pinned first.

    This intentionally forgets the internal permutation's position of
    `root_child`, modeling the unsafe proof shape.
    """

    free = tuple(x for x in block if x != root_child)
    return (root, root_child, *free)


def structured_word(root: int, ordered_block: tuple[int, ...]) -> tuple[int, tuple[int, ...]]:
    """Structured codomain retaining the full ordered child block."""

    return (root, ordered_block)


def main() -> None:
    root = 0
    block = (1, 2)
    root_child = 1

    total_block_orbit = list(permutations(block))
    pinned_images = {
        rho: pinned_word(root, root_child, rho) for rho in total_block_orbit
    }
    structured_images = {
        rho: structured_word(root, rho) for rho in total_block_orbit
    }

    print("K1-STEP0 root hygiene probe")
    print(f"root={root}, root_child={root_child}, block={block}")
    print(f"total block permutations: {len(total_block_orbit)}")
    print(f"pinned-word image count: {len(set(pinned_images.values()))}")
    print(f"structured image count: {len(set(structured_images.values()))}")

    assert len(total_block_orbit) == 2
    assert len(set(pinned_images.values())) == 1
    assert len(set(structured_images.values())) == 2

    print()
    print("Pinned-word collision:")
    for rho, image in pinned_images.items():
        print(f"  rho={rho} -> {image}")
    print()
    print("Structured route keeps the full orbit:")
    for rho, image in structured_images.items():
        print(f"  rho={rho} -> {image}")


if __name__ == "__main__":
    main()
