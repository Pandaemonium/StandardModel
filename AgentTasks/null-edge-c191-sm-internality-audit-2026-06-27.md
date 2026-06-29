# Gate C1 — `SMActsInternally` audit (Furey/Hughes internal sector + null-edge branch/CKM texture)

**Status of this document: audit / no-go job.** It does *not* assert the physical embedding
passes. It fixes what must be true, makes each requirement falsifiable, and lists the
convention choices that must be made before a certificate can even be stated.

The formal backbone is `RequestProject/Main.lean`
(namespace `GateC1.SMInternalityAudit`). The companion result `C177` (external to this repo)
proves gauge safety *given* `SMActsInternally`; here we make that antecedent concrete and
checkable.

The representation space is modelled as a tensor factorisation

```
  V  =  Branch ⊗ ( Flavor ⊗ Internal )
```

with operators written as matrices in the Kronecker basis indexed by `Br × (Fl × In)`
(`Op Br Fl In` in Lean). "Acts internally" means `T = id_Branch ⊗ M`
(`ActsInternally`, Main.lean §2).

---

## 1. Which factor carries the null-edge branch grading `J` and the CKM texture?

* **Branch grading `J` ↦ the `Branch` factor (`Br`).** `J` is, by design, the null-edge /
  NullStrand grading. In the model it is the operator that is diagonal in `Br` and trivial on
  `Fl ⊗ In`, i.e. `J = J_Br ⊗ id_(Fl⊗In)`. For gauge safety we never need `J` itself to act
  internally (it is a branch operator); we need every *gauge* generator and the *mass/CKM*
  operator to commute with this factorisation, i.e. to be `id_Branch ⊗ M`.

* **CKM texture ↦ the `Flavor` factor (`Fl`).** The generation index lives in `Fl`, and the
  CKM mixing is a unitary `U_CKM` acting on `Fl` only: `mass = id_Branch ⊗ (U_CKM-dressed
  mass on Fl) ⊗ (internal block)`. The whole point of the audit is that the CKM texture sits
  in `Fl` and therefore is allowed (it is on the internal side of the branch split), **provided
  it does not secretly act on `Br`.**

> **Central audit question.** Are `Br` (branch `J`) and `Fl` (generations/CKM) *genuinely
> independent tensor factors*? In the Furey/Hughes construction both the "ideal/branch" grading
> and the generation multiplicity are frequently realised on *the same* `ℂ⊗𝕆` (or `Cl(6)`)
> module — three generations as a triple of minimal left ideals, and any branch/edge grading as
> a further decomposition of that *same* module. If `J` and the generation index are read off
> the *same* algebraic data, then `V` does **not** factor as `Br ⊗ Fl ⊗ In`, and
> `SMActsInternally` is not even type-correct. This is the first thing the physical audit must
> establish, and it is a convention/representation choice (see §6).

---

## 2. Which factor do the SM gauge generators act on?

In the Furey/Hughes-style construction the SM gauge group is generated *inside the internal
algebra*:

* `SU(3)_c` and `U(1)_em`/`U(1)_Y` from the `ℂ⊗𝕆` ↔ `Cl(6)` ≅ `ℂ(8)` minimal-left-ideal
  module (Furey: the `su(3)` that stabilises a chosen complex structure on `𝕆`);
* `SU(2)_L` (weak isospin) from the complementary Clifford generators acting on the
  left-handed ideal.

So **every SM gauge generator should act on the `Internal` factor only**:
`gᵢ = id_Branch ⊗ id_Flavor ⊗ gᵢ^int`. Two separate demands are hidden here:

1. **id on `Branch`** — required by `ActsInternally` and hence by `C177`. This is what the audit
   formalises.
2. **id on `Flavor` (flavor-universality)** — the gauge action is the same for every generation.
   This is *not* needed by `C177` (which only quotients the branch), but it is physically
   mandatory and is a useful extra check; in the model it is the statement that the internal
   block `M = gᵢ` is itself `id_Flavor ⊗ gᵢ^int`.

---

## 3. Factorization conditions for "every generator is `id_Branch ⊗ gᵢ`"

Proved in `Main.lean` as `actsInternally_iff`:

```
ActsInternally T  ↔  NoBranchCoupling T  ∧  BranchIndependent T
```

* **`NoBranchCoupling T`** — `∀ i ≠ j, ∀ r r', T (i,r) (j,r') = 0`.
  The operator is block-diagonal in the branch index: distinct branches never mix.
* **`BranchIndependent T`** — `∀ i j r r', T (i,r) (i,r') = T (j,r) (j,r')`.
  All diagonal branch blocks are the *same* matrix `M` on `Flavor ⊗ Internal`.

Both are **decidable, entrywise** conditions, so an actual embedding either passes or fails them
by computation. The certificate `SMActsInternally gens mass` (Main.lean §5) requires exactly
this of every gauge generator in `gens` and of the branch/CKM `mass` operator.

(Flavor-universality, the optional extra demand of §2, is the same two conditions applied a
second time with the roles of `Br` replaced by `Fl` on the internal block `M`.)

---

## 4. Red flags — where a generator might accidentally mix the branch factor

Each red flag is a *falsifiable obligation*: if the pathology is present, the operator provably
cannot act internally. The detectors are `not_actsInternally_of_coupling` (violates
`NoBranchCoupling`) and `not_actsInternally_of_branchDependent` (violates `BranchIndependent`).

| # | Operation | How it could leak into `Branch` | Which condition it breaks |
|---|-----------|---------------------------------|---------------------------|
| R1 | **Weak chirality / `SU(2)_L`** (left projector `P_L`) | If left/right handedness is correlated with the branch (e.g. a branch *is* a chirality label, or `P_L` is defined via a phase that also rotates `J`), the `SU(2)_L` block differs per branch. | `BranchIndependent` |
| R2 | **Hypercharge `Y` / `U(1)`** | If the `U(1)` generator is built from the *same* number/grading operator used to define `J`, then `Y` eigenvalues depend on the branch, or `Y` and `J` are not simultaneously diagonalisable as independent factors. | `BranchIndependent` (or factorisation itself) |
| R3 | **Generation / flavor / CKM mixing** | If `Br` and `Fl` are not independent (the generation index and the branch grading are read from the same module — see §1), a "flavor" rotation `U_CKM` is secretly a `Br`-rotation and couples branches. | `NoBranchCoupling` |
| R4 | **Octonion ladder operators** (`Cl(6)` raising/lowering `αᵢ, αᵢ†`; Furey's `e_i`) | These shift the number eigenvalue. If `J` is defined as (a function of) that *same* number operator, the ladder operators **shift `J`**, i.e. map branch `i` to branch `i±1`. This is the deepest and most likely failure: the very generators that build the SM gauge group are the operators that move you between branches. | `NoBranchCoupling` |

Non-vacuity is certified by `branchSwap_not_internal` (Main.lean §6): an operator that swaps two
branches (a stand-in for an R3/R4 ladder/permutation leak) provably fails `ActsInternally`.

---

## 5. Lean / API certificate structure

In `RequestProject/Main.lean`, namespace `GateC1.SMInternalityAudit`:

```lean
abbrev Op (Br Fl In : Type*) := Matrix (Br × (Fl × In)) (Br × (Fl × In)) ℂ

def ActsInternally (T : Op Br Fl In) : Prop :=
  ∃ M : Matrix (Fl × In) (Fl × In) ℂ, T = (1 : Matrix Br Br ℂ) ⊗ₖ M

def NoBranchCoupling  (T : Op Br Fl In) : Prop := ∀ i j r r', i ≠ j → T (i,r) (j,r') = 0
def BranchIndependent (T : Op Br Fl In) : Prop := ∀ i j r r', T (i,r) (i,r') = T (j,r) (j,r')

theorem actsInternally_iff (T : Op Br Fl In) :        -- [Fintype Br] [DecidableEq Br] [Nonempty Br]
    ActsInternally T ↔ NoBranchCoupling T ∧ BranchIndependent T

theorem not_actsInternally_of_coupling        (...) : ¬ ActsInternally T   -- R3, R4 detector
theorem not_actsInternally_of_branchDependent (...) : ¬ ActsInternally T   -- R1, R2 detector

structure SMActsInternally (gens : List (Op Br Fl In)) (mass : Op Br Fl In) : Prop where
  gauge        : ∀ g ∈ gens, ActsInternally g
  massInternal : ActsInternally mass
```

To discharge the certificate for a concrete embedding one supplies, for each SM generator and
for the branch/CKM mass operator, either an explicit internal block `M` (giving `ActsInternally`
directly) or a proof of `NoBranchCoupling ∧ BranchIndependent` via `actsInternally_iff`. All
proofs are clean dependency-audit (`propext`, `Classical.choice`, `Quot.sound`).

---

## 6. Convention choices that must be fixed before the certificate can be stated

The audit **cannot be completed without** the following choices. Until they are fixed, the
physical `SMActsInternally` instance is not even well-typed, so no go/no-go verdict is possible.

1. **Factorisation convention (the load-bearing one).** Specify the isomorphism
   `V ≅ Br ⊗ Fl ⊗ In` *explicitly*. In particular, give the algebraic data from which `Br`
   (branch `J`) is read and the data from which `Fl` (generations) is read, and **prove they are
   independent**. If both come from the same `ℂ⊗𝕆` / `Cl(6)` module (the usual Furey/Hughes
   "three ideals" picture), no such factorisation exists and the answer is an immediate **no-go**
   (R3).

2. **Definition of `J`.** State whether `J` is (a) an external NullStrand label independent of
   the internal algebra, or (b) a function of the internal Clifford number operator `N = Σ αᵢ†αᵢ`.
   Choice (b) makes the ladder operators move `J` ⇒ **no-go** (R4).

3. **Generation realisation.** Fix how the three generations sit in `Fl` (independent
   multiplicity space vs. a grading of the same internal module) and where `U_CKM` acts. Only an
   independent `Fl` keeps R3 closed.

4. **Chirality convention.** Fix `P_L` and the handedness assignment, and state whether handedness
   is branch-correlated. A branch-correlated `P_L` triggers R1.

5. **Hypercharge normalisation / generator basis.** Fix the explicit `u(1)_Y` (and the `su(3)`,
   `su(2)`) generators as elements of the internal algebra, and the embedding
   `su(3)⊕su(2)⊕u(1) ↪ End(In)`. Required to even write `gens`; needed to close R2.

6. **Ground field / complex structure.** Fix the chosen complex structure `i` on `𝕆` (Furey's
   `ℂ⊗𝕆`) used to define the SM-stabilising subalgebra, and confirm it commutes with `J`. If it
   does not, R2/R4 reopen.

**Bottom line.** With the conventions above unfixed, the honest verdict is *not provable either
way*. The single most likely failure mode, on the standard Furey/Hughes realisation where
generations and any internal grading share one `ℂ⊗𝕆` module, is that the branch factor `Br` is
**not** independent of the internal/flavor data — so the SM ladder/gauge operators move between
branches and `SMActsInternally` is **false** (R3/R4). The Lean file makes this verdict
mechanically checkable once choices 1–6 are supplied.
