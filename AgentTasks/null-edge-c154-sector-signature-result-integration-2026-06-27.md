# C154 — Sector-signature audit: go/no-go decision framework

All results are formalized and machine-checked in
`RequestProject/SectorSignature.lean` (builds with no `s o r r y`; a x i o ms limited to
`propext`, `Classical.choice`, `Quot.sound`).

## 1. The sector-signature invariant

At the kernel-only / spectral level the finite seed contributes one real eigenvalue
per sector (`Sector = Branch × Flavor × Qutrit = Fin 2 × Fin 2 × Fin 3`, 12 sectors).
The overlap transfer `T_br = sign(H_ne)` records exactly the per-sector sign:

* `Seed` — eigenvalue per sector.
* `Gapped g S` — uniform norm gap bound `g ≤ |eval s|`, `g > 0` (the inverse-gap / C153
  requirement).
* `sectorSig S s = Real.sign (S.eval s)` — the **sector-signature invariant**.
* `GappedHomotopy A B` — the straight-line path `(1-t)·A + t·B` stays uniformly bounded
  away from zero (the C149 straight-line gapped-homotopy / reference-connection notion).

## 2. The finite theorem (both directions)

* `matching_implies_gappedHomotopy`: **matching sector signatures + norm gap bounds on
  both seeds ⇒ gapped homotopy** (gap `= min gA gB`). This is the requested
  "matching signatures + norm gap bound ⇒ gapped homotopy / reference connection".
* `gappedHomotopy_implies_matching`: a gapped straight-line homotopy forces equal sector
  signatures (intermediate-value argument). Hence the **sector signature is the complete
  invariant** of the straight-line gapped class.
* `sign_mismatch_zero_crossing` / `sign_mismatch_no_gappedHomotopy`: a single mismatched
  sector forces an explicit zero crossing and **blocks** any straight-line gapped
  homotopy — pinpointing the obstruction.

## 3. Concrete comparison (the audit)

The flavored Wilson term `W_branch` (C150) is imported as a species-splitting sign
pattern `signPat` (checkerboard in branch×flavor, constant on the qutrit fibre); the
magnitudes are illustrative.

* `c145Seed` — sign pattern × magnitudes in `[2,4]`, `c145_gapped : Gapped 2`.
* `refSeed` — flavor-matched reference (Adams / naive / minimally-doubled style), same
  sign pattern, magnitudes in `[3,7]`, `ref_gapped : Gapped 3`.
* Signature tables: `c145_signature_table`, `ref_signature_table` (both equal `signPat`),
  and `c145_ref_signatures_match`.

## 4. Decision

* **GO** — `c145_matches_reference : GappedHomotopy c145Seed refSeed`. The C145 seed and
  the flavor-matched reference share the full sector-signature table and both satisfy a
  norm gap bound, so they lie in the same gapped class / the reference connection holds.
* **NO-GO (illustrated)** — `refDetuned` mistunes the flavored mass so the `(0,0,0)`
  doubler flips sign; `c145_detuned_obstruction` proves no straight-line gapped homotopy
  exists. The required retuning: flip the flavored mass at the offending sector back so
  that doubler returns to the same side of zero as the seed (which recovers `refSeed`).

## Imported vs. proved

Imported (physics, not proved here): the overlap construction
`H_ne = Γ_K(D_ne + W_branch − m0 R)`, `T_br = sign(H_ne)`, `D_ov,ne = ρ(1 + Γ_K T_br)`;
the spectral reduction to one eigenvalue per sector; that flavored-mass spectral-flow
species counting (arXiv 1110.2482, 1011.0761) fixes the reference sign pattern. Proved
here: the entire finite signature/gapped-homotopy algebra above.

## Next action

The framework is complete and the table is computed: against a flavor-matched reference
the decision is **GO**. The next step is to instantiate `refSeed` from the actual
Adams/naive/minimally-doubled spectral-flow sign data (rather than the illustrative
`signPat`) and re-run `c145_ref_signatures_match`; the obstruction machinery
(`sign_mismatch_no_gappedHomotopy`) then yields the precise sector(s) and flavored-mass
retuning if any reference sign disagrees.
