# Strategy + proof: cast a checkerboard/quantum-walk Dirac model as a Krein carrier (F1)

## Context (blind to the wider repo)

A finite null-edge Dirac program builds "carriers": finite Dirac-type operators
`D = Σ_e c(α_e) ∇_e + Γφ` whose **square** `4 D^#D` decomposes into four
force-shaped channels — aperture/kinetic `Q_A`, closure/gauge `Q_C`, turn/Higgs
`Q_T = φ²`, and soldering/geometry `E_#`. Whether these channel names are *physics*
(not just algebra) is conjectural until a finite family converges to known continuum
objects. The highest-stakes bridge is to **discrete Dirac / quantum-walk** models,
which are already known to yield Weyl/Dirac propagation from null-step dynamics:

- Foster–Jacobson, "Spin on a 4D Feynman Checkerboard" (arXiv:1610.01142): a null-face
  checkerboard discretizing the Weyl equation without fermion doubling, with **mass as
  a chirality-flip amplitude**.
- Mlodinow–Brun, "Discrete spacetime, quantum walks and relativistic wave equations"
  (arXiv:1802.03910): symmetry forces a 4D internal space and Dirac structure in the
  continuum limit, with the **coin flip = mass operation**.

## Your task (strategy + proof)

Take the **1+1D Dirac quantum walk / checkerboard** (the cleanest case) and:

1. **Write the walk step as an explicit finite operator** (a `2×2`-coin ⊗ shift
   matrix, or the relevant small Krein/Clifford matrix): the massless walk (pure
   shift, two null directions) plus the mass/coin-flip term `m`.
2. **Cast it as a null-edge Krein carrier** in the program's shape `D = Σ c(α)∇ + Γφ`:
   identify the null covectors `c(α)` with the two lightlike step directions, the
   transports `∇` with the shifts, and the turn field `φ` with the coin-flip mass `m`.
3. **Compute the four-channel budget** `4 D^#D = Q_A + Q_C + 4Q_T + 4E_#` for this
   carrier and **prove the correspondence**: the aperture `Q_A` is the kinetic term,
   the turn `Q_T = φ² = m²` is the mass², the null-disagreement invariant reproduces
   the on-shell `E² = k² + m²` mass shell, and (for 1+1D) the closure `Q_C` and
   soldering `E_#` vanish or take their expected form.

The clean win: **a known checkerboard/QCA Dirac model IS a special case of the Krein
carrier, with the channel names matching the standard kinetic/mass structure** — the
first evidence that the four-channel budget is physics, not just algebra.

## Constraints

Kernel-checked only for any proved theorem: no `sorry`/`admit`/`native_decide`/new
`axiom`; footprint `[propext, Classical.choice, Quot.sound]`, guarded in-file. Mathlib
only. Clean-room from the cited papers' *mathematics* (do not copy code). Deliver Lean
file(s) + axiom prints + `ARISTOTLE_SUMMARY.md`: the walk-as-carrier identification,
which channel = which term, the mass-shell match, and honestly what does vs does not
line up (and whether 3+1D would need genuinely new structure).
