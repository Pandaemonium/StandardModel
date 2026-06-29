# C179 — Gate C1 Reference-Choice Audit (operator-side first target)

Status discipline: **Gate C1 is NOT closed.** This memo selects the *first* operator-side
reference to aim a real certificate at; it does not assert any C1 obligation is discharged.
It assumes the prior-job context: C170R (sub-gap homotopy with kappa, omega, rho, alpha, beta),
C175 (pure product/parity mass in d=4 splits 8+8, not one sector), C177 (CKM-like branch mass
gauge-safe under `SMActsInternally`), C178 (CKM is a fine *texture* reference but a literal
naive-product flavored-overlap operator is inadmissible unless proven doubler-resolved).

The C178 warning is the governing constraint. Everything below is ranked by how cleanly a
reference lets us *avoid the literal naive-product 8+8 trap of C175* while still being able to
carry a real homotopy/index certificate into C159.

---

## 0. The trap we are routing around (why C175 matters)

C175 is the load-bearing negative result. A naive flavored-overlap built as a *product* of a
parity/flavor structure with the kinetic overlap kernel in d=4 does not yield one physical
sector; it yields the 2^d = 16 = 8+8 doubler census reorganized as a product/parity mass.
"8+8" is the Nielsen–Ninomiya census talking: parity-paired doublers, half with each chirality.
A reference that *defines* its content by such a product silently re-imports those 16 modes and
then hides them inside a mass table that looks plausible (this is exactly the CKM-texture
seduction flagged in C178).

So the audit's first rule: **a reference is only admissible if its single-sector content is a
theorem about the operator, not a property of the mass table we read off it.**

---

## 1. Exact criteria for "doubler-resolved" in this context

A candidate reference operator `D` (acting on the lattice fermion field, in the relevant
representation, at the C170R sub-gap scale) is **doubler-resolved** iff it supplies ALL of:

- **(D1) Correct continuum mode count / index.** The number of exact (or sub-gap protected)
  zero/near-zero physical modes equals the intended single-sector count, NOT 2^d times it. For
  d=4 this is the difference between "1 sector" and "16 = 8+8". Concretely: an index/spectral-flow
  statement, e.g. `index D = ±(topological charge)` with the *correct* normalization, with no
  hidden multiplicity-16 factor.
- **(D2) Spectral gap away from the physical branch.** All non-physical (doubler-candidate)
  momentum branches carry a mass/eigenvalue bounded below by an O(1/a)-type gap that survives the
  C170R sub-gap homotopy, i.e. the gap constant must be compatible with (kappa, omega, rho).
  Doublers must be *lifted*, not merely *relabeled* by a parity dressing.
- **(D3) A Ginsparg–Wilson (GW) or GW-equivalent identity**, OR an explicit equivalent that
  guarantees an exact lattice chiral symmetry: `{D, gamma5} = a D gamma5 D` (Neuberger form) or
  the domain-wall 5D→4D-effective equivalent. This is what makes (D1) robust rather than an
  accident of tuning. *Tuning alone does not satisfy D3.*
- **(D4) No propagator-zero ghosts.** `D` must be invertible off the physical zero modes with the
  expected single-pole structure; in particular `1/D` may not develop *extra* zeros of the
  inverse (ghost poles) at the doubler momenta `p_mu ∈ {0, pi/a}^4 \ {0}`. The product/parity
  constructions of C175 are exactly the ones prone to this.
- **(D5) Locality.** `D` is local (exponentially bounded kernel) so that the index and gap
  statements are stable and the eventual C159 certificate is not voided by a non-local kernel.
  Neuberger overlap is local for admissible gauge backgrounds; this is a *hypothesis to carry*,
  not a freebie.
- **(D6) Gauge consistency under `SMActsInternally`.** The resolution mechanism must commute with
  the internal SM action used in C177, i.e. the doubler-lifting term must not mix gauge/flavor
  sectors (no gauge-mixing reintroduced through the Wilson/parity term). C177 gives this for the
  branch mass; the reference must inherit it.

A reference that gives (D1)+(D2) but not (D3) is "tuned-resolved" (fragile). A reference that
gives all of D1–D6 is "structurally resolved" (what C159 actually wants).

---

## 2. The five candidates, scored

Scoring each on: texture-match to CKM (T), avoids 8+8 trap (A), strength of certificate it can
hand to C159 (C), implementation/proof cost now (X). Scale: ++ strong / + ok / 0 neutral /
− weak / −− disqualifying.

| Ref | T (CKM texture) | A (avoids 8+8) | C (cert strength) | X (cost) | Notes |
|---|---|---|---|---|---|
| 1. CKM/tuned naive flavored-overlap | ++ | −− | − | + | Best texture, worst structure. The C178/C175 trap. |
| 2. Wilson/Neuberger overlap | + | ++ | ++ | 0 | GW identity → D3 for free. The reference standard. |
| 3. Adams/staggered-overlap | + | + | + | − | Reduced-doubler (taste) count; needs explicit taste-resolution proof. |
| 4. Domain-wall / boundary | + | ++ | + | − | D3 via 5D; residual-mass caveat; heavier object. |
| 5. Abstract block reference (scaffold) | 0 | n/a | 0 (placeholder) | ++ | Honest scaffold only; carries NO physical claim. |

---

## 3. Ranked recommendation for the FIRST physical reference target

**Rank 1 — Wilson/Neuberger overlap.** Adopt this as the first *physical* operator-side
reference. Reason: it is the unique candidate where (D3) is structural rather than tuned — the
Neuberger construction `D = (1/a)(1 + gamma5 sign(H_W))` satisfies the GW relation by
construction, so (D1) index and (D2) gap follow from a *proved* identity instead of a fitted mass
table. This is exactly what the C178 warning demands: single-sector content as a theorem about
the operator. It also lands closest to the C170R machinery (the sign-function / spectral-flow
structure is what the sub-gap homotopy constants kappa/omega/rho are already built to track).

**Rank 2 — Abstract block reference, as the *immediately adopted scaffold underneath Rank 1*.**
Not a physical target — a typed placeholder that records the C159 obligations (an `IsDoublerResolved`
predicate bundling D1–D6) so downstream work can be written against the interface *before* the
Neuberger index theorem is fully formalized. Use it only to hold the shape; it must never be
allowed to satisfy a C1 obligation on its own (see red flag R5).

**Rank 3 — Domain-wall / boundary reference.** The right *second* physical reference and the
natural cross-check on Neuberger (same GW physics, different realization). Demote for "first"
only because of the residual-mass (`m_res`) caveat: in the finite fifth-dimension version chiral
symmetry is approximate, so (D3) becomes (D3) + an explicit `m_res → 0` bound, i.e. more
certificate surface than Neuberger needs. Excellent for redundancy, heavier to stand up first.

**Rank 4 — Adams/staggered-overlap.** Keep as the texture-economical alternative. Staggered
already reduces 16→4 tastes; Adams' overlap-on-staggered can cut further. Attractive for matching
flavor/taste structure to a CKM-like table, but the taste-resolution step is an *extra* theorem
(taste index correctness) on top of the overlap index, so it is more total proof than Neuberger.
Promote it only if the CKM texture-match turns out to be a hard C159 requirement that Neuberger
cannot meet (it usually can, via the flavor index on top of a clean kinetic kernel).

**Rank 5 / DISQUALIFIED as a *first* target — CKM/tuned naive flavored-overlap.** Best texture
match, but it is precisely the literal naive-product operator C178 warned against and the
mechanism by which C175's 8+8 reappears. Admissible ONLY after an independent doubler-resolution
proof (D1–D6) is supplied by one of refs 2–4 and the CKM part is demoted to a *flavor texture
layered on top* of an already-resolved kinetic operator. As a standalone first reference: no.

---

## 4. CKM texture vs. the 8+8 trap — the clean resolution

The CKM data is a **flavor/mass-table reference, not a kinetic operator**. The trap in C175/C178
is the *multiplication* of CKM-like flavor structure into the kinetic kernel as a single naive
product, which entangles flavor with the doubler momenta and re-creates 8+8.

Correct factorization (the recommendation):

```
D_phys  =  D_kinetic(Neuberger, doubler-resolved)  ⊗  M_flavor(CKM texture)
```

with the **hard requirement** that `M_flavor` acts only on the *internal flavor index* and
is momentum-independent on the lattice Brillouin zone (no `p_mu`-dependence that could couple to
the doubler corners). Then:

- (D1)–(D6) are properties of `D_kinetic` alone and are inherited (CKM texture cannot spoil a
  proved index because it does not touch the kinetic spectral flow), and
- the CKM mass texture is matched at the level it actually lives — the flavor mass table —
  exactly as C178 endorsed.

So: **the reference that best matches CKM texture while avoiding the 8+8 trap is Neuberger
overlap kinetic kernel + CKM as a momentum-independent flavor mass factor**, NOT a flavored
overlap defined by a single naive product. This is the operational content of "use CKM as a
texture reference, not as the operator."

---

## 5. What theorem/certificate each reference must supply for C159

For each reference, the C159-facing deliverable is a typed certificate
`IsDoublerResolved D` ≙ (D1 ∧ … ∧ D6) plus the reference-specific witness:

- **Ref 1 (CKM/tuned naive):** must supply an *independent* doubler-resolution proof for the
  product operator itself — i.e. show the naive product does NOT realize C175's 8+8. Given C175,
  the honest expectation is this certificate is **unprovable as stated**; the deliverable is
  really a *no-go restatement* unless refactored per §4. C159 should treat a bare Ref-1 request
  as a red flag (R1).
- **Ref 2 (Neuberger):** the **Ginsparg–Wilson identity** `gamma5 D + D gamma5 = a D gamma5 D`
  (or `2a`-normalized variant), plus the **overlap index theorem** `index D = Q_top` with correct
  normalization (no factor 16), plus **locality for admissible backgrounds** and the **sub-gap
  compatibility** statement tying the Wilson-kernel spectral gap of `H_W` to (kappa, omega, rho).
  This is the cleanest C159 certificate.
- **Ref 3 (Adams/staggered-overlap):** the **taste-index correctness** theorem (16→4→1 reduction
  is faithful, no leftover taste doublers) on top of an overlap GW identity for the staggered
  kernel. Two stacked index statements.
- **Ref 4 (domain-wall):** the **5D→4D effective-overlap equivalence** (Ls→∞ gives Neuberger),
  the **residual-mass bound** `m_res(Ls) ≤ C·exp(−c·Ls)` (or algebraic, depending on
  transfer-matrix gap), and the resulting *approximate* GW identity with explicit error. C159
  must accept a quantitative-GW certificate, not exact-GW.
- **Ref 5 (abstract block):** supplies **nothing physical** — only the *interface*: the Prop
  `IsDoublerResolved` and the statement that any concrete reference discharging it feeds C159.
  Its only theorem is a *plumbing* lemma ("if `D` satisfies D1–D6 then the C1 sub-obligation
  reduces to …"). Must be marked clearly as scaffold so it cannot be mistaken for a closure.

---

## 6. No-go / red-flag cases (where doublers, ghost poles, or gauge-mixing creep back silently)

- **R1 — Naive product as operator (C175 redux).** Any reference whose single-sector content is
  read off a *mass table* produced by multiplying flavor × kinetic kernels. Silently restores
  8+8. Symptom: index computed from the table, not from the operator. **Hard stop.**
- **R2 — "Tuned" passing for "resolved".** A reference that achieves (D1)+(D2) by parameter
  tuning without (D3) GW. Doublers are gap-lifted at the tuned point but the protection is not
  topological; any deformation in the C170R homotopy can collapse the gap. Symptom: gap constant
  depends on tuned mass with no GW identity backing it. Demote to "tuned-resolved", do not feed
  C159 as resolved.
- **R3 — Ghost propagator zeros.** Parity/flavor-dressed kernels whose *inverse* acquires extra
  zeros at doubler corners `{0,pi/a}^4\{0}` → ghost poles in `1/D`. Violates (D4). Symptom: the
  doubler is removed from the spectrum of `D` but reappears as a zero of `det` away from the
  physical mode, or a wrong-sign residue. Especially likely in Ref 1 and in careless Ref 3 taste
  splittings.
- **R4 — Gauge/flavor mixing via the lifting term.** If the doubler-lifting (Wilson-type) term is
  not internal w.r.t. `SMActsInternally`, it re-introduces gauge-mixing that C177 explicitly
  cleared for the branch mass. Violates (D6). Symptom: the Wilson/parity term carries a gauge
  index. Must check the lifting term commutes with the C177 internal action.
- **R5 — Scaffold mistaken for closure.** Treating the Ref-5 abstract block (or any
  proof-placeholder-backed `IsDoublerResolved`) as if it discharged a C1 obligation. The interface asserts
  nothing physical; allowing it to "count" silently closes C1 on an empty hypothesis. **Hard
  stop on any finish/closure claim that depends on an unfilled `IsDoublerResolved`.**
- **R6 — Domain-wall residual-mass swept under the rug.** Using domain-wall as if GW were exact
  while `Ls` finite. The `m_res ≠ 0` chiral breaking is a small explicit doubler/chirality leak;
  if not bounded it silently violates (D3). Symptom: GW identity invoked without an `m_res` error
  term.
- **R7 — Locality lost.** Neuberger/overlap is local only for admissible gauge backgrounds; on
  rough/non-admissible backgrounds `sign(H_W)` can be non-local and the index theorem fails.
  Violates (D5). Carry admissibility as an explicit hypothesis, do not assume it.

---

## 7. One-line bottom line

**First physical reference = Neuberger/Wilson overlap kinetic kernel, with CKM kept strictly as a
momentum-independent flavor mass factor on top; stand up an explicit `IsDoublerResolved`
(D1–D6) interface (abstract block) underneath it immediately, and treat any bare CKM/naive-product
flavored-overlap request as the C175/C178 trap until an independent resolution proof exists.**
Gate C1 remains open.
