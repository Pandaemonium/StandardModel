# Report: `FiniteNielsenNinomiya.lean`

Namespace: `PhysicsSM.Draft.NullEdge.GateYM.FiniteNielsenNinomiya`.
Imports: `Mathlib` only. Typechecks with `lake env lean FiniteNielsenNinomiya.lean`
(no full `lake build` needed). No `sorry`, `axiom`, or `native_decide` anywhere.

## Deliverables vs. request

1. **Discrete setup.** `gamma5 = !![1,0;0,-1]`; `gamma5_sq : γ5*γ5 = 1`,
   `trace_gamma5 : tr γ5 = 0`. Chiral symmetry `ChiralSym D := γ5*D*γ5 = -D`.
   `chiralSym_iff_offDiag` proves this ⇔ both diagonal entries vanish, and
   `chiralSym_offDiag_form` gives the explicit `D = !![0, f; g, 0]`.

2. **Winding invariant, well-definedness.** For a nowhere-zero symbol
   `f : ZMod N → ℂ`, `winding_exists` proves the total discrete arg-increment
   `∑_p arg(f(p+1)/f p)` is `2π·k` for an integer `k` (telescoping in
   `Real.Angle = ℝ/2πℤ`, using that `∏_p f(p+1)/f p = 1`). `winding f : ℤ` is
   defined and `winding_eq` shows `windingSum f = 2π · winding f`.

3. **Concrete no-go instance (`N = 4`), fully computed / sorry-free.**
   - `fCanon N p = exp(2πi p/N) - 1`; `fCanon_eq_zero_iff` proves its zeros are
     exactly `p = 0` (for every `N`).
   - The genuine naive Hermitian symmetric-difference dispersion `sin(2π p/4)`
     is `naiveSin4 = ![0,1,0,-1]`. `nodes4`: node set `= {0, 2}` (origin +
     Brillouin-zone doubler at `p = N/2`). `chirality4_zero = +1`,
     `chirality4_two = -1`. `signedNodeCount4_eq_zero`: the chirality-weighted
     node count is `0` (by `decide`). This is the honest "price of the turn":
     the `+1` Weyl node at the origin is forced to have a `-1` doubler.

4. **General statement + necessity corollary.** `signed_sum_telescope`: for any
   discrete chirality/branch `h : ZMod N → ℤ`, `∑_p (h(p+1) - h p) = 0` — the
   boundaryless discrete circle forces the total signed count to vanish.
   `odd_signedCount_impossible`: an odd signed count is therefore impossible under
   chiral symmetry, so lifting a lone Weyl zero requires a chirality-even
   (Wilson) term.

## Honesty / scope

- This is explicitly the **1D finite lattice** version, not the full 4D continuum
  Nielsen–Ninomiya theorem.
- The `winding` of a *nowhere-zero* symbol can be any integer (the SSH invariant);
  it is **not** claimed to be zero. What vanishes is the signed count assembled
  from a globally consistent branch around the boundaryless loop
  (`signed_sum_telescope`).
- The higher-dimensional degree-theoretic argument is discussed only informally in
  the file's closing comment; it is **not** left as a `sorry` — there are no
  sorries in the file.

## Axiom footprint

`#print axioms` for `signedNodeCount4_eq_zero`, `fCanon_eq_zero_iff`,
`winding_exists`, `winding_eq`, `signed_sum_telescope`, `chiralSym_iff_offDiag`
all report exactly:

```
[propext, Classical.choice, Quot.sound]
```

(The concrete `N = 4` theorem is kernel-checked via `decide`, no `native_decide`.)
