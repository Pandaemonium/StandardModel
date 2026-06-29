# C157 — Furey/Hughes/SM `J_not_gauged` audit

Round: `gate-c1-reference-match`. Companion Lean module:
`RequestProject/C157_GaugeInternality.lean` (builds clean, no `s o r r y`; the packaged
result `sm_native_gauge_safe` uses only the axioms `propext` and `Quot.sound`).

This note records the audit reducing the physical Standard-Model embedding question
to explicit assumptions, as required by the C157 success criterion.

---

## 0. C144 recap (the dichotomy being instantiated)

C144 proves an abstract go/no-go: the native Gate C1 seed (`H_ne = Γ_K(D_ne +
W_branch − m0 R)`, `T_br = sign(H_ne)`, `D_ov,ne = ρ(1 + Γ_K T_br)`) is gauge-safe
**iff** the gauge representation does not gauge the branch operator `J` (the `Γ_K`
sign that the native seed transfers). In one line:

> native Gate C1 gauge-safe ⇔ every gauge generator commutes with `J`  (`J_not_gauged`).

C157 asks whether the *intended* Furey/Hughes/SM representation satisfies
`J_not_gauged`.

---

## 1. Project-level intended factors (Deliverable 1)

The native-seed representation space is read as a tensor product

```
V  =  B  ⊗  (spin/flavor)  ⊗  I_FH
```

| factor | role | carries `J`? |
|--------|------|--------------|
| `B` (branch) | null-edge / chirality grading; `J = Jb ⊗ id`, `Jb` the chirality sign `diag(1,−1)` | **yes** |
| spin/flavor | Lorentz/Dirac spin and generational flavor index | no |
| `I_FH` (Furey/Hughes internal) | complex octonions `ℂ ⊗ 𝕆 ≅ ℂ⁸`; equivalently the `ℂl(6)` action giving `SU(3)×U(1)` and, via the second Cayley–Dickson chain, `SU(2)` | no |

The SM gauge group `SU(3)_c × SU(2)_L × U(1)_Y` is realized **inside `End(I_FH)`**
in the Furey/Hughes construction (left-multiplication / Clifford-action operators on
the complexified octonions). For the `J_not_gauged` question, spin/flavor and `I_FH`
can be bundled into one "internal" factor `I`; the only relevant datum is *whether a
gauge generator touches `B`*.

In the Lean module: `branchOp Jb = Jb ⊗ id` is `J`; `internalOp gi = id ⊗ gi` is an
internal gauge generator.

---

## 2. Is branch `J` outside the gauge representation? (Deliverable 2)

In the intended construction the SM gauge generators are built purely from
octonionic/Clifford operators on `I_FH` and **do not reference the branch grading**.
Algebraically they have the tensor form `g = id_B ⊗ gᵢ`. Such operators commute with
`J = Jb ⊗ id` because both products equal `Jb ⊗ gᵢ`:

- Lean: `internal_gauge_commutes` — `Commute (id_B ⊗ gᵢ) (Jb ⊗ id_I)`.

So *as intended*, `J` is **outside** the gauge representation. The genuine risk is
that a particular generator-by-generator realization secretly mixes the branch
(off-diagonal in the `J`-grading); then `J` is gauged and native mode fails:

- Lean: `swap_does_not_commute_sign` — a branch-mixing generator `[[0,1],[1,0]]` does
  **not** commute with the chirality sign `diag(1,−1)`;
- Lean: `gauged_branch_breaks_JNotGauged` — any set containing a generator that fails
  to commute with `J` violates `J_not_gauged`, i.e. native mode is unsafe.

This is exactly the no-go side of C144 made concrete.

---

## 3. Precise checklist / theorem (Deliverable 3)

**Assumption `SMActsInternally G`:** every SM gauge generator `g ∈ G` has the form
`g = id_B ⊗ gᵢ` for some `gᵢ ∈ End(I)` (the generator acts only on the internal
Furey/Hughes factor and as the identity on the branch factor).

**Theorem `sm_native_gauge_safe`:** if `SMActsInternally G`, then
`NativeGateC1Safe G (Jb ⊗ id)` — i.e. `J_not_gauged` holds and C144 applies, so
native Gate C1 is gauge-safe.

Checklist to discharge `SMActsInternally` for a concrete realization:

1. Fix the branch factor `B` and the branch operator `Jb` (the `Γ_K` sign). ✔ in
   model: `B = ℂ²`, `Jb = diag(1,−1)`.
2. List the SM gauge generators (8 gluons of `SU(3)`, 3 of `SU(2)_L`, hypercharge
   `U(1)_Y`).
3. For **each** generator, exhibit `gᵢ ∈ End(I_FH)` with `generator = id_B ⊗ gᵢ`
   (i.e. it is block-diagonal w.r.t. the `Jb` chirality grading and acts equally on
   both chiralities — up to the chiral hypercharge/`SU(2)_L` assignment, see §4).
4. Then `internal_gauge_JNotGauged` gives `J_not_gauged`, and `sm_native_gauge_safe`
   gives gauge-safety.

The physical embedding question is thereby reduced to the single explicit
assumption in step 3.

---

## 4. Ambiguity / convention risks (Deliverable 4)

These are the places where step 3 of the checklist can silently fail.

1. **Chirality vs. branch identification.** The dangerous coupling is precisely
   between gauge and the chirality/branch grading. `SU(2)_L` and hypercharge act
   **chirally** in the SM. If the branch factor `B` is identified with (or shares a
   tensor leg with) the L/R chirality that `SU(2)_L`/`U(1)_Y` distinguish, then those
   generators are *not* of the form `id_B ⊗ gᵢ` and `J_not_gauged` fails. The
   construction must keep the null-edge branch `J` **logically distinct** from the
   weak-isospin chirality. This is the #1 assumption to record.

2. **Octonion non-associativity / choice of action.** `𝕆` is non-associative, so
   "the internal algebra acts on `I_FH`" must be made precise: one works with the
   associative envelope `ℂl(6) ≅ End_ℂ(ℂ⁸)` via **left-multiplication maps** `L_a`
   (Furey) or the equivalent Clifford generators (Hughes). The gauge generators are
   specific associative operators; conventions differ on:
   - left vs. right multiplication maps,
   - the complex structure `i` used to complexify (the `i` of `ℂ` vs. an octonionic
     unit), which fixes which `U(1)` is hypercharge,
   - the Cayley–Dickson basis/sign conventions and the choice of "preferred" unit
     `e₇` that breaks `G₂ → SU(3)`.
   A different convention can move a generator's action onto a different tensor leg.
   The audit assumption must pin the action to `End(I_FH)` *only*.

3. **`U(1)` normalization / which `U(1)` is gauged.** The Furey number-operator
   `U(1)` (from `ℂ⊗𝕆`) must be the one identified with hypercharge and must act
   inside `I_FH`; a mis-identification that ties it to the branch number operator
   would gauge `J`.

4. **Spin/flavor leakage.** Bundling spin/flavor into `I` is safe *only if* no gauge
   generator acts on the branch leg. If a generation/flavor mixing is implemented via
   an operator that also reshuffles the branch grading, `SMActsInternally` fails.

---

## 5. Recommended recorded assumptions (Deliverable 5)

Before any repo doc or Lean module claims "gauge-safe native mode" for the SM, record
these as explicit, named assumptions (Lean `variable`/hypotheses, not axioms):

- **A1 (branch ⟂ gauge):** the null-edge branch factor `B` carrying `J` is a tensor
  leg disjoint from every factor any SM gauge generator acts on. Formal handle:
  `SMActsInternally G` in `C157_GaugeInternality.lean`.
- **A2 (chirality split):** the branch grading `Jb` is **not** the weak-isospin /
  hypercharge chirality; `SU(2)_L` and `U(1)_Y` act inside `I_FH` only (§4.1).
- **A3 (associative action fixed):** the Furey/Hughes internal action is given by a
  fixed associative representation (`ℂl(6) ≅ End(ℂ⁸)` left-mult maps), with the
  complex structure, octonion basis, and preferred unit all fixed in one convention
  (§4.2–4.3).
- **A4 (no spin/flavor → branch leakage):** flavor/generation operators preserve the
  branch grading (§4.4).

With A1–A4, `sm_native_gauge_safe` discharges the claim. **Without an explicit check
of A1/A2 this is a no-go**, because chiral gauge couplings are exactly what can gauge
`J` (`swap_does_not_commute_sign` / `gauged_branch_breaks_JNotGauged`).

**Suggested placement:** add A1–A4 to the Gate C1 native-mode README and re-export
`SMActsInternally` + `sm_native_gauge_safe` as the project-facing API gate; any
downstream "native mode is gauge-safe" lemma should take `SMActsInternally` as a
hypothesis rather than assume it silently.

---

## 6. Bottom line

The SM embedding question reduces to the single explicit assumption
`SMActsInternally` (every gauge generator `= id_B ⊗ gᵢ`), refined by conventions
A2–A4. Under it, C144 applies and native Gate C1 is gauge-safe
(`sm_native_gauge_safe`, machine-checked). The decisive physical risk is chiral
gauge/branch identification (A2); if violated, the concrete no-go theorems show `J`
is gauged and native mode is unsafe. This is a clean reduction to assumptions, not a
proof that the physical SM automatically satisfies them — A1/A2 must be verified
generator-by-generator in the chosen Furey/Hughes convention.
