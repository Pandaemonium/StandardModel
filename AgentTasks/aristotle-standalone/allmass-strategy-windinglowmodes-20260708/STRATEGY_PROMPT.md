# Strategy + proof: which closure backgrounds accumulate low modes? (F4)

## Context (blind to the wider repo)

A finite null-edge Dirac program found a clean **negative** result: *random* closure
disorder does NOT accumulate near-zero modes (so "generic mess makes mass" is false).
The frontier is the sharpened positive question: **which STRUCTURED closure
backgrounds accumulate low modes?** The physics candidates are topological — a
closure background carrying a **winding / topological charge** `w` (an instanton-like
finite configuration), where a finite **index theorem** should force `≥ |w|`
protected near-zero modes, in contrast to the `w = 0` (random) case.

This is the finite shadow of Banks–Casher / chiral-condensate physics; the program is
careful NOT to claim a true condensate before a thermodynamic limit exists. So the
target is a *finite* index/low-mode theorem, not a spectral-density claim.

## Your task (strategy + proof)

1. **Formalize a finite "winding" closure background.** On a finite cyclic/graph
   carrier (e.g. `Fin N` with a translation/shift structure), define a closure
   operator `K_w` carrying an integer winding `w` — e.g. a finite discrete
   connection whose holonomy around the cycle is `exp(2πi w/N)`, or a shift-by-`w`
   structure. Keep it small and explicit.
2. **Index ⇒ protected low modes.** Prove a finite theorem: the Dirac/closure
   operator built from `K_w` has an index (a chiral asymmetry, or a spectral-flow /
   winding count) equal to `w`, forcing `≥ |w|` exact zero modes (or, if only
   near-zero is available finitely, a lower bound on the count of modes below a
   controlled gap). Contrast with `w = 0`: no protection.
3. **Pre-register the refinement question.** State (as a conjecture with a kill
   condition, not a theorem) whether the protected count survives refinement
   `N → 2N → …` — i.e. whether it is a genuine finite shadow of a continuum index or
   a lattice artifact.

The clean win is: **a winding/topological closure background provably accumulates
low modes that random disorder cannot** — a falsifiable, computationally concrete
structural mechanism for mass generation.

## Constraints

Kernel-checked only for any proved theorem: no `sorry`/`admit`/`native_decide`/new
`axiom`; footprint `[propext, Classical.choice, Quot.sound]`, guarded with in-file
`#print axioms`. Mathlib only; use the pinned toolchain you scaffold. Deliver the
Lean file(s), axiom prints, and `ARISTOTLE_SUMMARY.md` with: the winding-background
definition, the index/low-mode theorem, and an honest statement of what is proved
finitely vs. conjectured under refinement. If the clean index theorem resists,
deliver the strongest finite partial + a precise proof plan.
