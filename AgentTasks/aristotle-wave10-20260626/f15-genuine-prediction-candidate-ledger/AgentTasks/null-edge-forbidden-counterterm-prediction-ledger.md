# F14 — Forbidden-counterterm codimension to prediction-ledger bridge

Type: Prediction / Audit / Proof
Date: 2026-06-26
Primary Lean module: `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean`
Related: `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`,
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §§20.9, 22, 23, 25.6,
job backlog rows F7/F9/F11/H8.

## Verdict (one line)

The Wave 8 theorem is a **kernel-clean internal consistency / reconstruction
theorem about the finite operator square**, *not* a Gate F prediction. The
codimension it computes lives in the space of finite matrices on `L ⊕ R`, not in
`M_EFT`, and the "forbidding" is the *definition* of a `Γ_s`-odd (`chi_E`-odd)
Dirac operator. It must therefore **not** be advertised as a first structural
prediction. It is a sound bookkeeping/reconstruction result and a *necessary
ingredient* for a future Gate F argument, but the prediction gate stays closed.

---

## 1. What finite parameter space is actually reduced?

The theorem `forbidden_counterterm_codimension` works in:

```text
ambient space = Matrix (L ⊕ R) (L ⊕ R) ℂ      (all zero-order operators on the
                                                finite chiral square)
dim_ℂ ambient = (|L| + |R|)^2
```

`diagBlocks` is the ℂ-linear map sending an operator to its two
chirality-preserving blocks `(M|_{L→L}, M|_{R→R})`. The theorem proves:

```text
codim(ker diagBlocks) = dim (Matrix L L ℂ × Matrix R R ℂ) = |L|^2 + |R|^2.
```

The new sharpening added in this job makes the bookkeeping literal:

```text
ambient_finrank                    : dim ambient            = (|L|+|R|)^2
admissible_odd_finrank             : dim (ker diagBlocks)   = 2·|L|·|R|
ambient_eq_admissible_add_codim    : (|L|+|R|)^2 = 2·|L|·|R| + (|L|^2 + |R|^2)
```

So the reduced space is **the off-diagonal Yukawa/Higgs block space** of the
*internal finite square*. The admissible (odd) operators are exactly the
`2·|L|·|R|` off-diagonal entries; the forbidden directions are exactly the
`|L|^2 + |R|^2` diagonal (same-Weyl) entries.

Crucially, the parameter space being reduced is **`M_finite`’s internal Dirac
block `Φ_H`**, *before* any map to `M_EFT`. It is not `M_EFT` and it is not the
image of `F : M_finite → M_EFT`.

## 2. Connection to the Gate F rule

Gate F (§20.9, §16.15) demands one of:

```text
rank(dF) < dim M_EFT        (image is a proper, lower-dim subvariety)
R(θ_EFT) = 0                (a forced nontrivial relation among EFT couplings)
```

with `F : M_finite → M_EFT`, `M_EFT = {g1,g2,g3,v,λ,Y_u,Y_d,Y_e,Y_ν,M_R,CKM,
PMNS,Λ_QCD, Wilson coeffs}`.

The forbidden-counterterm theorem supplies a codimension statement, but in the
**wrong space**:

- It is a codimension *inside the domain block `Φ_H ⊂ M_finite`*, realized by an
  algebraic constraint ("`D` is odd"). It is `dim(forbidden) = |L|^2 + |R|^2`.
- Gate F needs a codimension *of the image `F(M_finite) ⊂ M_EFT`*, i.e. a
  deficit in `rank(dF)` or a relation `R(θ_EFT)=0`.

A constraint on the *domain* is not a constraint on the *image* unless one shows
that (a) the forbidden directions would otherwise have produced independent,
*physical, non-redundant* EFT parameters, and (b) they are not already removed by
symmetries that the SM EFT itself imposes. Neither (a) nor (b) is established by
the theorem. So the theorem is the `rank(dF)` *ingredient* the working plan calls
it (the docstring's "`rank(dF) < dim M_EFT` ingredient"), but it is **not** the
inequality itself.

## 3. The abstract Lean theorem (task 3) — added and proved

Task 3 asked for "a small abstract Lean theorem saying that forbidding diagonal
blocks cuts the full block matrix space by the stated codimension." This is now
present and kernel-checked (axioms: `propext, Classical.choice, Quot.sound`):

```text
theorem ambient_eq_admissible_add_codimension :
    finrank ℂ (Matrix (L ⊕ R) (L ⊕ R) ℂ)
      = finrank ℂ (ker diagBlocks) + (|L|^2 + |R|^2)
```

together with the two supporting dimension lemmas `ambient_finrank` and
`admissible_odd_finrank`. This states exactly that forbidding the diagonal blocks
removes `|L|^2 + |R|^2` parameters from the full `(|L|+|R|)^2`-dimensional block
matrix space, leaving the `2·|L|·|R|` admissible off-diagonal parameters. It is a
literal "cuts the space by the codimension" statement, complementing the existing
quotient-`finrank` form.

These lemmas are honest finite linear algebra and make no continuum or physical
claim.

## 4. Which SM/EFT counterterms this is and is not

**Forbidden directions = diagonal, chirality-preserving (same-Weyl) zero-order
mass blocks `L→L` and `R→R`.** In SM/EFT language these correspond to:

- a bare Majorana-type mass coupling two same-chirality Weyl fields
  (`L_L L_L`-type, or `R^c R^c`-type same-Weyl bilinears), i.e. a
  chirality-*even* mass insertion that does not flip `L ↔ R`.

**Admissible directions = off-diagonal `L↔R` Yukawa/Higgs blocks**, i.e. the
ordinary Dirac mass / Yukawa structure that flips chirality.

Adversarial point — *this is largely already imposed by known physics*:

- A same-chirality (Majorana) bare mass for the SU(2)×U(1)-charged left fields is
  **already forbidden at the renormalizable level by SM gauge invariance**: a
  left-handed Majorana mass is the dimension-5 Weinberg operator
  `(L H)(L H)/Λ`, not a renormalizable counterterm, and is gauge-forbidden as a
  bare mass. So for the gauge-charged sector the chirality grading forbids
  exactly what gauge invariance already forbids. No *new* restriction on
  `M_EFT`.
- For a gauge-singlet right-handed neutrino `N_R`, a Majorana mass `M_R N_R N_R`
  is **allowed and physical** in the SM EFT (it is in `M_EFT` as `M_R`). The
  finite chirality grading would forbid it as a *diagonal* block. This is the one
  place where the grading says something the SM does not — but here the grading
  is *more restrictive than nature appears to allow* (seesaw `M_R` is a standard
  ingredient). That makes it a **modeling assumption to be checked against
  neutrino phenomenology**, not a clean prediction; if the null-edge model truly
  forbids `M_R`, that is a falsifiable stance on neutrino mass origin (Dirac vs.
  Majorana), and should be flagged as such, not sold as a generic codimension
  win.

What it does **not** cover: dimension-5/-6 Wilson coefficients, Pauli
(magnetic-moment `σ_{μν}F`) counterterms, kinetic-term / wavefunction
renormalization, gauge couplings, Higgs potential parameters, CKM/PMNS angles.
The theorem is silent on all of these; it only addresses zero-order mass blocks
on the finite square.

## 5. Is the codimension "built into the choice of `chi_E`-odd `Φ_H`"?

**Yes — and this is the decisive adversarial finding.** `IsOdd M` is *defined* as
`{Γ_s, M} = 0`, and `isOdd_iff_offDiagonal` proves oddness is *equivalent* to
the diagonal blocks vanishing. So:

- "forbidding the diagonal counterterm" and "choosing `Φ_H` to be `chi_E`-odd"
  are the **same statement**. The codimension `|L|^2 + |R|^2` is the dimension of
  the complement of the odd subspace by construction.
- The theorem does not *derive* oddness from a deeper dynamical/geometric input
  (e.g. the full soldered null-edge Dirac operator forcing the grading). It
  *posits* oddness (the NCG first-order/odd axiom) and counts what that excludes.

This is precisely the Gate C blocker noted in the Wave 8 summary ("whether the
full operator forces the modeled chirality/taste signs"). Until the full
operator is shown to *force* `Γ_s`-oddness, the codimension is a consequence of an
assumption, not a prediction.

## 6. Classification: prediction vs consistency vs reconstruction

Using the working-plan ledger language (§16.14, §16.15, §25.6):

| Candidate label | Holds? | Reason |
|---|---|---|
| First structural **prediction** | ✗ | Codimension is in `M_finite`’s `Φ_H` block, not in `rank(dF)`/`R(θ_EFT)`; and it is definitional to `chi_E`-odd choice. Overlaps known gauge selection rules. |
| **Consistency theorem** | ✓ | Kernel-clean: any odd operator has vanishing diagonal blocks; admissible = off-diagonal; dimensions add up. Internally exact. |
| **Reconstruction constraint** | ✓ | It reconstructs the standard fact that NCG/odd-Dirac fluctuations are chirality-flipping Yukawa terms, with an explicit parameter count. Legitimate as "coherent reconstruction" per §20.12. |

**Recommended manuscript label:** *finite consistency / reconstruction theorem*
with an explicit parameter count. Safe sentence:

```text
In the locked chirality-graded finite square, admissible (odd) zero-order mass
operators are exactly the off-diagonal Yukawa blocks (dim 2|L||R|); the
chirality grading removes the |L|^2+|R|^2 diagonal same-Weyl mass directions.
This reconstructs the off-diagonal structure of NCG Yukawa fluctuations and
supplies a parameter-count ingredient for the Gate F ledger; it is not yet a
prediction on M_EFT.
```

Forbidden sentences: "first prediction", "forbidden counterterm prediction",
"codimension constraint on the Standard Model".

## 7. Acceptance / failure criteria for upgrading to a real Gate F result

To promote this from reconstruction to prediction, **all** of the following Lean
targets are required:

1. **Force the grading (close Gate C).** Prove that the *full* soldered null-edge
   Dirac operator (not a posited odd block) anticommutes with `Γ_s` — i.e.
   oddness is a theorem, not the definition. Target: a `superDirac_isOdd` lemma
   over the realized operator, feeding `isOdd_iff_offDiagonal`.
2. **Map to `M_EFT` and show non-redundancy.** Construct (even schematically)
   `F : M_finite → M_EFT` and show the forbidden directions would have produced
   *physical, field-redefinition-invariant* EFT parameters. Without a
   redundancy/field-redefinition quotient this stays a "fake deficit" (§16.15
   warning).
3. **Separate from gauge invariance.** Show the forbidden mass is *not* already
   excluded by SM gauge invariance/Lorentz — i.e. isolate the gauge-singlet
   `M_R` (Majorana neutrino) sector and decide explicitly whether the model
   forbids `M_R`. If it does, state it as a falsifiable neutrino-sector claim
   (Dirac-only neutrinos) and cross-check phenomenology.
4. **Counterterm-rank impact (F11).** Confirm that branch-control / Wilson-like
   counterterms (Gate C, §23.3) do not re-open the forbidden directions
   radiatively; otherwise the codimension is unstable under RG and not a
   prediction.

Failure criterion: if (1) cannot be proved (the operator does not force
oddness), or (2) shows the map is full-rank after removing redundancies, then the
result is permanently a reconstruction statement and the prediction label must
stay off.

## 8. Lean patch delivered

`PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean` gains three lemmas (all
kernel-clean, axioms `propext, Classical.choice, Quot.sound`):

- `ambient_finrank` : `dim ambient = (|L|+|R|)^2`.
- `admissible_odd_finrank` : `dim (ker diagBlocks) = 2|L||R|`.
- `ambient_eq_admissible_add_codimension` : the explicit split
  `dim ambient = dim(ker diagBlocks) + (|L|^2 + |R|^2)`.

These fulfill task 3 (the abstract "cuts the full block matrix space by the
codimension" theorem) and make the parameter bookkeeping explicit for the Gate F
ledger. No statement was weakened; no `sorry`/`axiom`/`native_decide` added. The
focused package omits `PhysicsSM/StandardModel/AnomalyPackage.lean`, so
`NullEdgeInternalSpectrum.lean` does not build in this snapshot (expected per
`FOCUSED_PACKAGE_NOTE.md`); the modified module imports only Mathlib and builds
under the pinned toolchain.

## 9. Semantic-alignment note

- `chirality`/`chiralityVal` match `NullEdgeSuperDiracBlockCore.chirality`
  (`+1` on `L`, `-1` on `R`).
- "odd" = `{Γ_s, M} = 0` is the NCG/null-edge first-order odd-Dirac convention.
- The codimension is measured in `M_finite`’s internal block, **not** `M_EFT`;
  this is the alignment the report flags as the gap to Gate F.
