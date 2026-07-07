# PROOF JOB: Ginsparg-Wilson structure of inverted-by-involution transfer maps

Lean 4 + Mathlib. Finite algebra; one abstract lemma plus one concrete 8x8
verification. No sorry, no new axioms, no native_decide; axiom footprint
within [propext, Classical.choice, Quot.sound]. Namespace
`PhysicsSM.Draft.NullEdge.Carrier.GWTransfer`; `import Mathlib` only.
Deliverable: one file `GWRetardedTransfer.lean`. Context file shows house
style only.

## Targets

1. **`gw_of_involution_inverts` (GW-1, the abstract lemma).** Let `R` be a
   (noncommutative) ring, `eps : R` central and invertible... simplest honest
   form: work in `Matrix (Fin n) (Fin n) C` or an abstract
   `[Ring A]`-algebra over C. Hypotheses: `G * G = 1` and `G * V * G = V⁻¹`
   for invertible V (state with `IsUnit V` or explicit inverse witness
   `V * Vinv = 1`, `Vinv * V = 1`, `G * V * G = Vinv`). Define
   `D := 1 - V` (absorb the 1/eps scaling: state the identity in the
   unscaled form). Claim:
   `G * D + D * G = D * G * D`.
   (Proof: expand; `G*D + D*G - D*G*D = G - V*G*V`; and
   `V*G*V = G` from `G*V*G = Vinv` i.e. `V*G = G*Vinv` gives
   `V*G*V = G*Vinv*V = G`.) Also prove the companion:
   **`deformed_involution`**: `Ghat := G * V` satisfies `Ghat * Ghat = 1`
   and `D * Ghat = - (G * D) + (G + Ghat) - 1`... CHECK the exact companion
   identity yourself and state the correct one; the intended content is
   Luscher's exact deformed symmetry in one-step form: `Ghat` is an
   involution and `D * Ghat = -G * D` PLUS correction terms that vanish -
   verify whether `D * Ghat = -G * D + (1 - V) ... ` holds exactly as
   `D * Ghat = -G * D` (compute: `D*Ghat = (1-V)GV = GV - VGV = Ghat - G`
   and `-G*D = -G + GV = Ghat - G`. So `D * Ghat = -G * D` EXACTLY - prove
   that).
2. **`gamma5_hermiticity`.** If additionally V is J-unitary for a fundamental
   symmetry structure... keep it algebraic: if `star V * V = 1` (unitary in a
   star ring) and `star G = G`, then `star D = G * D * G`. (Star-ring
   formulation over Matrix C is fine.)
3. **`checkerboard_verification` (GW-2 kill-check, 8x8).** On
   `V8 := (Fin 4) × (Fin 2)` (4 spatial sites on a ring, 2 chirality
   components), define the midpoint checkerboard transfer with FORMAL mass
   parameter: to keep it kernel-decidable, work over the field
   `C` with `costh` and `sinth` as two real parameters satisfying
   `costh^2 + sinth^2 = 1` (hypothesis), or - simpler and preferred - verify
   the CONJUGATION identity structurally: define
   `S : shift by +1 on right-movers, -1 on left-movers` (a permutation
   matrix on the 8-dim space), `Cm := block-diagonal corner rotation`
   (cos/sin 2x2 at each site), `T := Shalf * Cm * Shalf` where
   `Shalf` is... the half-shift does not exist on the integer lattice;
   USE THE EQUIVALENT one-sided convention `T := Cm * S` and prove the
   conjugated identity: with `Gr := (sigma_z at each site) * (spatial
   reflection x -> -x)` (an explicit 8x8 signed permutation), prove
   `Gr * T * Gr = Tinv` where `Tinv` is the explicit inverse
   (`S⁻¹ * Cm⁻¹`; both explicit: S is a permutation, Cm a rotation), OR
   determine and document the exact half-shift conjugation correction if
   the identity requires the midpoint convention - in that case prove the
   identity for `T' := S * Cm * S⁻¹ ... ` hmm: half-shifts require doubling
   the lattice; acceptable fallback: verify on the DOUBLED ring Fin 8 where
   the half-shift of the 4-ring is an honest shift. Choose whichever
   formulation gives an exact kernel identity, DOCUMENT the convention
   choice prominently, and if the identity FAILS in all reasonable
   conventions, deliver the counterexample computation as the result (that
   is a fully successful outcome - it kills a conjecture cheaply).

## Provenance for docstrings

Ginsparg-Wilson (Phys. Rev. D 25 (1982) 2649); Luscher's exact deformed
symmetry (Phys. Lett. B 428 (1998) 342). The abstract lemma is the one-step
transfer form: an involution conjugating the transfer to its inverse yields
the GW relation with R = 1/2 exactly. The physics reading (the grading is
chirality composed with spatial reflection = edge-orientation reversal;
retardation makes the hypotheses hold) stays in prose.
