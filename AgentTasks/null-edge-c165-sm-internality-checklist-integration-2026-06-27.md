# C165 — Generator-level `SMActsInternally` checklist (Furey/Hughes conventions)

Status: specification + verified Lean skeleton.
Lean artifact: `RequestProject/SMInternalityChecklist.lean`
(namespace `PhysicsSM.NullEdge.SMInternality`), builds clean, no `s o r r y`,
a x i o ms `[propext, Quot.sound]` only.

This job moves beyond the *abstract* C157 reduction

> native gauge safety reduces to `SMActsInternally`: every gauge generator acts
> as `id_B ⊗ g_i` relative to the branch factor; if a generator mixes branch `J`,
> native mode fails

to a **concrete, generator-level** checklist for a Furey/Hughes-style internal
representation, with a Lean API and machine-checked structural theorems.

---

## 0. Modelling frame

Total internal one-particle space (one Brillouin/null-edge seed point):

```text
Total = B ⊗_K V
```

* `B` — **branch factor**, carrying the null-edge branch grading `J` (corner
  parity / branch level of the C155/C162 point-split seed). *No* gauge generator
  may act on this factor in native mode.
* `V` — **internal value space**: the Furey/Hughes representation space carrying
  `su(3) ⊕ su(2)_L ⊕ u(1)_Y` plus any flavor/generation action.

An operator `T : End_K(B ⊗ V)` is **internal** iff `T = id_B ⊗ g` for some
`g : End_K V` (Lean: `InternalForm T := ∃ g, T = TensorProduct.map id g`).
The branch grading is `J ⊗ id_V`. The whole result rests on two formal facts:

1. `id_B ⊗ g` commutes with `J ⊗ id_V` (so internal ⇒ branch not gauged).
2. For complementary branch projectors (`Q ∘ P = 0`) the off-diagonal block
   `(Q⊗id) ∘ (id⊗g) ∘ (P⊗id) = (Q∘P) ⊗ g = 0` — any nonzero branch-mixing block
   forbids internality.

---

## 1. Generator checklist — families to check

Each family must be confirmed to have the form `id_B ⊗ g_i` (acts only on `V`).

| # | Family | Count | Lean field | What to check |
|---|--------|-------|------------|---------------|
| 1 | `SU(3)` color | 8 (Gell-Mann `λ_a`) | `su3 : Fin 8 → End` | each `λ_a` realised as `id_B ⊗ g_a`, `g_a` the color action on `V`; closes on `su(3)` |
| 2 | `SU(2)_L` weak isospin | 3 (`T^1,T^2,T^3`) | `su2L : Fin 3 → End` | each `T^i = id_B ⊗ g_i`, acting only on the left-handed doublet sub-block of `V`, **not** on `B` |
| 3 | `U(1)_Y` hypercharge | 1 | `u1Y : End` | `Y = id_B ⊗ g_Y` with the **bridge-fixed normalisation** (see risk H) |
| 4 | flavor/generation | `|Φ|` | `flavor : Φ → End` | any generation-mixing/family action relevant to the null-edge seed acts as `id_B ⊗ g_p`; **must not** be realised through the branch factor `B` |

Family 4 is the subtle one: in a finite seed it is tempting to encode generations
through the same hypercube that carries the branch grading. The checklist
explicitly demands the flavor action live on `V`, disjoint from `J` on `B`.

---

## 2. Meaning of `id_B ⊗ g_i` relative to branch `J` (per family)

For a generator `T`:

* **Internal form** (`InternalForm T`): `T = id_B ⊗ g` — `T` ignores the branch
  index and acts identically on every branch sector.
* **Branch-factor disjoint** (`BranchFactorDisjoint J T`): `T ∘ (J⊗id) = (J⊗id) ∘ T`
  — `T` commutes with the branch grading, i.e. it preserves every branch level
  / corner-parity eigenspace and never transports amplitude between branches.
* **No branch-mixing block** (`MixingBlock P Q T = 0` for complementary `P,Q`):
  the `P`-sector→`Q`-sector block of `T` vanishes.

Theorem chain (all verified):
`InternalForm` ⇒ `BranchFactorDisjoint` (`internalForm_branchDisjoint`) and
`InternalForm` ⇒ every complementary `MixingBlock` is `0`
(`mixingBlock_eq_zero_of_internal`).

---

## 3. Convention risks (Furey/Hughes bridge required)

Respecting the repo octonion-convention warning, the abstract operators above
must **not** be filled from Furey formulas without first fixing a bridge:

* **R1 — Octonion basis / sign convention.** Furey's `e_i` multiplication table
  and the chosen associator signs change which `g_a` you write down. Fix a single
  multiplication table and orientation in the bridge doc; record it.
* **R2 — Associative left-action algebra vs raw octonion products.** The SM
  generators live in the associative left-action algebra
  `ℂℓ(6) ≅ End_ℂ(ℂ⊗𝕆)` acting by left multiplication, **not** in raw
  (non-associative) octonion products. Generators must be built as left-action
  operators on `V`; raw products do not give well-defined `End V`.
* **R3 — Weak chirality vs null-edge branch grading.** Weak chirality is the
  `SU(2)_L` doublet projector on `V`; the branch grading `J` lives on `B`. These
  are **different gradings on different factors** and must not be identified. The
  Lean predicate `WeakChiralityNotBranch` records this (chirality is `InternalForm`,
  hence commutes with `J⊗id`).
* **R4 — Hypercharge normalisation.** `Y` normalisation (e.g. `Q = T_3 + Y/2`
  vs `Q = T_3 + Y`, and the `1/3` color factors) must be pinned in the bridge.
  Internality is normalisation-independent, but downstream anomaly/charge claims
  are not.
* **R5 — Preferred complex structure / unit.** The complex structure used to view
  `𝕆_ℂ` (which imaginary unit `i` is "the" `ℂ`) selects the unbroken `SU(3)×U(1)`.
  Fix it once; a different unit gives a different (possibly branch-entangling)
  embedding.

---

## 4. Lean / API checklist (implemented)

All of the following are in `RequestProject/SMInternalityChecklist.lean`:

```text
def InternalForm (T)                         -- T = id_B ⊗ g
def BranchFactorDisjoint J T                  -- T commutes with J ⊗ id
def MixingBlock P Q T                         -- (Q⊗id) ∘ T ∘ (P⊗id)
def WeakChiralityNotBranch J chir            -- chir internal ∧ commutes with J⊗id
def InternalGeneratorFamily gen              -- ∀ i, InternalForm (gen i)
structure SMGenerators … (su3, su2L, u1Y, flavor)
def SMActsInternally S                       -- all four families internal
def JNotGauged J S                           -- all generators branch-disjoint
structure NativeGaugeSafetyAssumptions       -- internal ∧ chirality_internal

theorem internalForm_branchDisjoint          -- internal ⇒ branch-disjoint
theorem mixingBlock_eq_zero_of_internal      -- internal ⇒ no mixing block
theorem SMActsInternally.jNotGauged          -- CHECKLIST ⇒ JNotGauged
theorem weakChirality_branchDisjoint         -- internal chirality ≠ branch grading
```

The headline implication `SMActsInternally ⇒ JNotGauged` is
`SMActsInternally.jNotGauged`.

---

## 5. No-go theorem (branch-mixing block ⇒ native mode fails)

```text
theorem not_internal_of_mixingBlock_ne_zero
    (hPQ : Q ∘ₗ P = 0) (hne : MixingBlock P Q T ≠ 0) : ¬ InternalForm T

theorem SMGenerators.not_smActsInternally_of_mixingBlock_ne_zero
    (hPQ : Q ∘ₗ P = 0) (i) (hne : MixingBlock P Q (S.all i) ≠ 0) :
    ¬ SMActsInternally S
```

**Statement.** If *any* SM/flavor generator has a nonzero branch-mixing block
between complementary branch projectors `P, Q`, then `SMActsInternally` is false,
and (by the contrapositive of `SMActsInternally.jNotGauged`) native gauge safety
via the `id_B ⊗ g` route is lost — the branch grading `J` is gauged.

---

## 6. Assumptions to record before claiming native gauge safety

Bundle `NativeGaugeSafetyAssumptions J S chir` collects the minimum to record:

1. **`internal : SMActsInternally S`** — every generator of `su3/su2L/u1Y/flavor`
   verified, *in the bridged convention*, to be `id_B ⊗ g_i`.
2. **`chirality_internal : InternalForm chir`** — weak chirality is a `V`-factor
   operator, kept separate from `J`.

Plus, as docs (not yet load-bearing in this module, but required before a physical
claim):

3. The **convention bridge** R1–R5 above, written down explicitly.
4. A statement that this is a claim *about a chosen Furey/Hughes realisation*, not
   about the physical SM (see claim boundaries).

From (1)+(2), `NativeGaugeSafetyAssumptions.jNotGauged` yields
`JNotGauged J S ∧ WeakChiralityNotBranch J chir`.

---

## Go / No-go statements

* **GO (conditional):** *If* a Furey/Hughes realisation supplies `SMGenerators`
  with `SMActsInternally S` in a recorded convention bridge, *then* `JNotGauged`
  holds — the null-edge branch grading `J` is not gauged, and native gauge safety
  for `J` follows. Machine-checked: `SMActsInternally.jNotGauged`.
* **NO-GO:** *If* any generator carries a nonzero branch-mixing block between
  complementary branch projectors, `SMActsInternally` is false and native mode
  fails. Machine-checked: `not_internal_of_mixingBlock_ne_zero`,
  `SMGenerators.not_smActsInternally_of_mixingBlock_ne_zero`.

### Claim boundaries (honoured)

* We do **not** claim the physical SM satisfies `SMActsInternally`; it is a
  hypothesis to be discharged per realisation.
* We do **not** conflate weak chirality (a `V`-factor projector) with the
  null-edge branch grading `J` (a `B`-factor operator); the API keeps them on
  distinct tensor factors.
* We do **not** copy Furey formulas; the generator fields are abstract `End`
  data pending the R1–R5 convention bridge.

---

## Recommended next verification tasks

1. **Convention-bridge doc (R1–R5).** Fix octonion table/signs, complex unit,
   hypercharge normalisation; the prerequisite for any instantiation.
2. **Instantiate `V` and the left-action algebra.** Build `V = ℂ⊗𝕆` (or the
   `ℂℓ(6)`/spinor model) and realise `su3/su2L/u1Y` as left-action operators;
   discharge `SMActsInternally` for that instance.
3. **Flavor/generation audit.** Confirm the generation action of the null-edge
   seed (family 4) is `id_B ⊗ g_p` and not encoded through `B`; this is the most
   likely source of a branch-mixing block.
4. **Tie `J` to the concrete seed.** Connect `branchGrade J` to the C162
   point-split branch projectors / corner-parity grading so `JNotGauged` is about
   the *actual* `W_branch` seed.
5. **Wire into C159 import interface.** Expose `NativeGaugeSafetyAssumptions` as
   the gauge-safety certificate consumed by `NullEdgeReferenceOverlapImport`.
6. **(Optional) Spectral/anomaly bridge.** Once internality holds, record that the
   hypercharge normalisation (R4) feeds the separate anomaly certificate — it is
   *not* implied by `SMActsInternally`.
