# Hostile audit — massless 3+1 ordered-Pauli crossing census

Scope: adversarial review of the claimed exact massless charge census in
`B_MASSLESS_CHARGE_CENSUS_ORACLE_2026-07-11.md`, `MEMO_3PLUS1_ATTACK.md`,
`SPARK_LIT_MASSLESS_CROSSING_CENSUS_2026-07-11.md`, and the four Lean files
`FullBlochSplitDeterminants.lean`, `FullBlochGlobalChirality.lean`,
`codex_24h_b_live_weyl_jacobian.lean`,
`codex_24h_b_massless_bloch_crossing_classification.lean`.

The mathematics was independently recomputed (ordered Pauli product, real
Jacobian, determinant factorisation, crossing set by global Newton search, the
16 determinant signs, both sector sums, the 4×4 zero/π membership, and the two
factorisation identities). A self-contained Mathlib-only artifact
`AUDIT_CONTROL.lean` was added that **proves** the arithmetical heart of the
census (see §7); it builds with no `sorry` and depends only on
`propext, Classical.choice, Quot.sound`.

---

## 0. Verdict

The **mathematics of the census is correct**. The **Lean status is not**: as
delivered, *nothing in the repository builds*, so *no* theorem in the project is
verified, and the central census claim (per-sector charge sum `= 0`) is **not
even stated** in any Lean file — it lives only as SymPy/prose. Any manuscript
sentence of the form "we prove in Lean that …" is currently unsupported by the
repository.

Severity legend: **S1** blocking / claim-invalidating · **S2** high · **S3**
medium · **S4** low / wording.

---

## 1. S1 — The entire project fails to compile; no theorem is verified

Every one of the four project files imports modules under
`PhysicsSM.Draft.NullEdge.*` that **do not exist anywhere** in the repository or
the toolchain search path:

```
FullBlochSplitDeterminants.lean          import …NullEdge.Compact3Plus1DiracRate
FullBlochGlobalChirality.lean            import …NullEdge.FullBlochSplitDeterminants, …CubicWeylSectorCharge
codex_24h_b_live_weyl_jacobian.lean      import …NullEdge.SU2LocalCrossingCharge, …CubicWeylSectorCharge
codex_24h_b_massless_bloch_crossing_classification.lean
                                         import …NullEdge.FullBlochZeroClassification
```

`lake build` on any target aborts with `unknown module prefix 'PhysicsSM'`.
Consequences:

- The sorry-free files (`FullBlochSplitDeterminants`, `FullBlochGlobalChirality`)
  are **not** verified: they never elaborate. Their in-file `#print axioms`
  guards (`splitStep_eq`, `body_center_both_polynomials_zero`) are therefore
  vacuous — the guard cannot fire on a file that does not compile.
- Note also that the import path `PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants`
  does not even correspond to the repository file `FullBlochSplitDeterminants.lean`
  (which would resolve as `import FullBlochSplitDeterminants`), so the intended
  dependency wiring is internally inconsistent, not merely missing.

**Do not report any of these theorems as proved.** They are, at best, "prepared
statements against an absent library."

## 2. S1 — The census conclusion is not stated in Lean anywhere

The oracle memo itself is explicit: *"Status: exact SymPy algebra/oracle, not
Lean proof,"* and lists four obligations "not landed until Lean proves." Item 4
— *"the sixteen exact determinant signs and the two finite sums"* — has **no
Lean statement at all** in the repository:

- `codex_24h_b_live_weyl_jacobian.lean` states the Pauli decomposition, the
  Jacobian, its determinant, and two single-point controls, but **never** the
  16-point census or any sector sum. Every theorem there is `by sorry`.
- `codex_24h_b_massless_bloch_crossing_classification.lean` states the crossing
  *set* (in cosine coordinates) but **never** a charge or a sum. Every theorem
  there is `by sorry`.

So the headline result ("the total charge cancels separately in the 0 and π
sectors") is an **oracle restatement**, not a theorem. §7 supplies the missing
Lean statement and proof for the 2×2 Weyl sector.

## 3. S2 — Everything substantive is `sorry`

Both `codex_*` files are 100% `sorry` (8 + 8 theorems). Combined with §1 this
means the crossing classification, the Jacobian identity `det J =
u0·(cos²qy−sin²qy)`, the Pauli decomposition `weylStep = pauliForm`, the fderiv
identification, and all controls are **unproven**. They are, however,
*mathematically true* (independently checked, §6), so they are targets worth
finishing rather than false claims.

## 4. S2 — Zero-vs-π assignment: 2×2 Weyl census ≠ 4×4 Dirac classification

There are **two different objects** in play and the memo blurs them:

- The oracle memo works with the **2×2** positive-Weyl symbol
  `U(q)=e^{-iqxσ1}e^{-iqyσ2}e^{-iqzσ3}`. Here `U=±I` is a *single* value at each
  node, so each crossing lies in exactly one sector (`+I`≡"0", `−I`≡"π"). The
  clean `4 − 4 = 0` per sector is a **2×2 statement** and is correct.
- The classification file works with the **4×4** Dirac `splitStep … 0 1` and
  its `det(U∓1)`. Independent computation shows that at every **body center**
  (`cos qx=cos qy=cos qz=0`) *both* `det(U−I)=0` **and** `det(U+I)=0`: the body
  centers are **simultaneously 0-modes and π-modes** (a degenerate double
  crossing). This is exactly what `body_center_both_polynomials_zero` and the two
  `…_massless_eq_zero_iff` lemmas encode (both sector polynomials share the
  `x=y=z=0` branch).

Verified determinant magnitudes (massless, 4×4):

| point | `|det(U−I)|` | `|det(U+I)|` | reading |
|---|---|---|---|
| origin `(0,0,0)` | 0 | 16 | pure 0-mode |
| corner `(π,0,0)` | 16 | 0 | pure π-mode |
| body `(π/2,π/2,π/2)` | 0 | 0 | **both sectors** |

**Attack:** a naïve "0-sector charge sum" and "π-sector charge sum" built from
the 4×4 classification would **double-count all eight body centers** (once in
each sector). The separate-cancellation claim is only unambiguous for the 2×2
Weyl restriction (or after a definite eigenvector-level assignment of each 4×4
body center to one branch). The manuscript must state which object it means; the
safe object is the 2×2 sector.

## 5. S3 — Convention and completeness caveats (each real, none fatal)

1. **Periodic identification is load-bearing.** A global Newton search of
   `u1=u2=u3=0` over `(−π,π]³` returns 35 raw representatives; these collapse to
   **8 corners + 8 body centers = 16 only after identifying `π ≡ −π`** (corners
   range over `{0,π}³`, body centers over `{±π/2}³`). The count "8 cube corners"
   is *false* without this quotient (there are 27 corner representatives in
   `{−π,0,π}³`). The classification file's use of **cosine coordinates**
   (`x=cos qx`, …) is the correct fix, since `cos` is automatically
   `2π`-periodic and even; the memo prose should say so explicitly.

2. **Per-point charge signs are convention-dependent.** The charge
   `sign(det J)` depends on (a) the ordering of the output components
   `(u1,u2,u3)`, (b) the ordering of the inputs `(qx,qy,qz)`, and (c) the overall
   sign convention. The determinant factor singles out **`qy`** asymmetrically
   (`cos²qy − sin²qy = cos 2qy`) purely because of the `σ1σ2σ3` product order;
   this is a real feature, not a bug (independently reproduced), but it means the
   individual `±1` values are **not canonical**. What *is* convention-independent
   is that each sector sum vanishes: a global sign flip or a coordinate
   permutation multiplies both sums by the same `±1` and preserves `0`. Present
   the *cancellation*, not the per-node signs, as the invariant statement.

3. **`charge = sign(det J)` is the Weyl monopole degree only because the nodes
   are nondegenerate.** At all 16 points `det J = ±1 ≠ 0`, so `u:ℝ³→ℝ³` has an
   isolated nondegenerate zero and its local degree is `sign(det J)`. State
   nondegeneracy (`det J = ±1`) as a hypothesis/lemma before calling the number a
   topological charge.

## 6. Positive confirmations (independently recomputed)

- **Pauli coefficients** `u0,u1,u2,u3` from `e^{-iqxσ1}e^{-iqyσ2}e^{-iqzσ3}`:
  correct (rederived by hand, `σ1σ2=iσ3`, etc.).
- **`weylJacobian` matrix** in `codex_24h_b_live_weyl_jacobian.lean` equals the
  true `∂u_i/∂q_j` entrywise (all 9 entries checked).
- **Determinant identity** `det J = u0·(cos²qy − sin²qy)`: holds (max error
  `5·10⁻¹⁶` over 10⁵ random points). It is *not* a free polynomial identity — it
  needs `sin²+cos²=1` on the `x` and `z` axes (verified: free-variable error is
  `O(10³)`). Now proved in `AUDIT_CONTROL.detJm_eq`.
- **Crossing set**: exactly the 8 corners + 8 body centers after the `π≡−π`
  quotient (Newton search, §5.1).
- **Sector sums**: `Σ_{U=+I} sign(det J) = 0` and `Σ_{U=−I} sign(det J) = 0`
  (all 16 dets are `±1`). Now proved in `AUDIT_CONTROL` (§7).
- **Classification factorisations** `algebra{Zero,Pi}_massless_factor` and the
  zero-set lemmas: mathematically true (factorisation error `~10⁻¹⁵`; the
  sum-of-squares form forces the stated zero-set on the cube). They are correct
  targets, merely unproven and unbuildable.
- **Negative controls** are genuine (non-vacuous): origin is a 0-mode
  (`det(U−I)=0`), `(π,0,0)` is *not* (`det(U−I)=16≠0`); the rank-deficient
  control `(0,π/4,0)` has `det J = u0·(cos²45°−sin²45°) = 0`.

## 7. Corrected theorem ladder (and what `AUDIT_CONTROL.lean` closes)

A defensible ladder, weakest hypotheses first. Rungs marked **[done]** are
proved in `AUDIT_CONTROL.lean` (Mathlib-only, no `sorry`); the rest remain to be
landed against a *building* library.

1. **[repo blocker]** Restore the missing `PhysicsSM.Draft.NullEdge.*` modules
   (or repoint the imports) so the four files elaborate. Until then rungs 2–6
   below cannot even be type-checked in-repo.
2. **Pauli decomposition** `weylStep = pauliForm` (2×2) — currently `sorry`.
3. **Jacobian = derivative** `fderiv weylVector = weylJacobian` — currently
   `sorry`.
4. **Determinant identity** `det J = u0·(cos²qy − sin²qy)` — **[done]** as
   `AUDIT_CONTROL.detJm_eq` (self-contained real proof).
5. **Nondegeneracy + 16 exact signs** `det J = ±1` at each node — **[done]** as
   `AUDIT_CONTROL.det_c0…det_q3` (16 lemmas, each an exact real value).
6. **Separate cancellation** (the actual headline) — **[done]** for the 2×2
   sector as `AUDIT_CONTROL.zero_sector_charge_sum = 0` and
   `pi_sector_charge_sum = 0`; `total_charge_sum = 0` is included and explicitly
   flagged as *weaker* (it would hold even without separate cancellation, so it
   is not a substitute).
7. **4×4 bridge (open):** if the manuscript wants the 4×4 Dirac statement, add a
   lemma assigning each body center to a single branch at eigenvector level
   (resolving the §4 double-membership) before summing; otherwise restrict the
   claim to the 2×2 Weyl sector.

Because every determinant is exactly `±1`, `sign(det J) = det J` at each node, so
the real sums in `AUDIT_CONTROL` *are* the signed-charge census sums. This closes
oracle-obligation #4 for the 2×2 sector without touching or weakening any
existing target.

## 8. S4 — Literature / originality

`SPARK_LIT_MASSLESS_CROSSING_CENSUS_2026-07-11.md` supports at most a **narrow**
originality claim, and even that only weakly:

- Full-text chunks were available for **only one** of the four anchors
  (`1802.03910`); `2006.04204`, `1806.06868`, `1705.08552` were seen at
  abstract/metadata level. Any "novel relative to the literature" statement rests
  on incomplete full-text access and should be hedged accordingly.
- None of the four anchors states the census in the literal ordered normal form
  `e^{-iqxσ1}e^{-iqyσ2}e^{-iqzσ3}`; the closest (Mlodinow–Brun) is a coined-shift
  directional product, and Floquet 0/π chiral counting (Bessho) and 3D
  Weyl-node/BCC characterisations (D'Ariano, Higashikawa) are **established
  prior art** in their own conventions.

**Safe claim scope:** the contribution is a *convention-specific* exact census —
the 16-node cube-corner + body-center 0/π Jacobian-charge bookkeeping for the
*specific* ordered-Pauli-exponential normal form — not a new physical
counting principle. Floquet 0/π charge accounting and 3D discrete-time Weyl-node
counting are not new.

## 9. Suggested safe manuscript wording

> For the ordered massless step `U(q)=e^{-iqxσ1}e^{-iqyσ2}e^{-iqzσ3}` on the
> principal torus (`qj` identified mod `2π`), the zero-mode set consists of the
> eight cube corners `qj∈{0,π}` and the eight body centers `qj∈{±π/2}`. With the
> crossing charge defined as the sign of the Jacobian determinant of the Pauli
> vector `(u1,u2,u3)` — which we show equals `u0·(cos²qy − sin²qy)` and takes the
> value `±1` at every node, so each node is nondegenerate — the total charge
> cancels **separately** within the `U=+I` (quasienergy 0) and `U=−I`
> (quasienergy π) sectors: `Σ_{+I} = Σ_{−I} = 0`. The per-node sign depends on
> the coordinate/gate ordering convention; the sector-wise cancellation does not.
> The accompanying Lean development `AUDIT_CONTROL.lean` proves the determinant
> identity, the sixteen exact node determinants, and both sector sums for the
> 2×2 Weyl sector (Mathlib only, no `sorry`).

Avoid: "we prove in Lean that …" for any claim depending on the four project
files as shipped (they do not build); "there are exactly 8 corners" without the
`π≡−π` identification; presenting the individual `±1` charges as canonical; a
0/π *4×4* partition without resolving the body-center double-membership; and any
unqualified priority claim over the four literature anchors.
