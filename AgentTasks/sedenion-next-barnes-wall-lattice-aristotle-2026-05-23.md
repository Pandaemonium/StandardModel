# Aristotle N5: Barnes-Wall lattice construction moonshot

Create or modify:

```text
PhysicsSM/Draft/Sedenions/BarnesWallLatticeConstructionMoonshot.lean
```

## Big Goal

Move beyond the current "Barnes-Wall first-shell candidate" theorem and test
actual lattice constructions.

The current honest claim is a Reed-Muller/Barnes-Wall parity shadow.  This job
should try to define explicit lattice candidates and prove or refute their
basic invariants.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.ReedMullerCode
PhysicsSM.Draft.Sedenions.BarnesWallFirstShell
PhysicsSM.Draft.Sedenions.Z4KerdockRefinementMoonshot
```

If `Z4KerdockRefinementMoonshot` is not available in the context, ignore that
import and work from the existing modules.

## Desired Theorems

Try one or more finite/lattice candidates:

1. Construction A from `C_ZD` in length 16.
2. A Construction D proxy using the Reed-Muller chain
   `RM(0,4) <= RM(1,4) <= RM(2,4)`.
3. A signed or `Z4`-phase lattice candidate if N3 has provided a lift.

For each candidate, prove or compute:

- determinant or index in `Z^16`;
- minimum squared norm over a bounded shell;
- evenness or a counterexample to evenness;
- whether the 168 signed plaquette vectors lie in the first shell;
- whether the construction can plausibly be `Lambda_16`.

Suggested theorem names:

```lean
theorem constructionA_cZD_index : ...
theorem constructionA_cZD_even_or_counterexample : ...
theorem constructionD_RM_chain_minimum_shell : ...
theorem signed_plaquettes_mem_candidate_first_shell : ...
theorem cZD_lattice_not_yet_BarnesWall_or_candidate_summary : ...
```

## Constraints

- Do not claim an isomorphism to Barnes-Wall unless a concrete comparison is
  defined.
- A negative theorem about Construction A from `C_ZD` is valuable.
- No axioms, opaque constants, unsafe code, or admits.
