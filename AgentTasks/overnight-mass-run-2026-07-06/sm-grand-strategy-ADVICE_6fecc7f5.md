# Grand-strategy advice — "origin of mass from null edges"

Strategy/advice only; no Lean build performed. Literature (Q4) checked live with
`curl` against `arxiv.org` and `ar5iv.org` (Kanazawa, arXiv:0808.3442); exact
inequalities transcribed below from that source, not from memory.

---

## Q1 — Highest-EV next steps (ranked)

**Lane-C pivot: YES, pivot to Tomboulis–Yaffe (TY); demote KP off the critical path.**
Rationale:
- The Kotecký–Preiss / Fernández–Procacci labeled-tree bound is a genuinely hard
  analytic result whose payoff is only *convergence of one particular expansion*.
  It is brittle and is not the shortest path to the north star.
- TY reduces the whole area-law/gap claim to (i) reflection positivity (already
  landed), (ii) an iterated reflection / Cauchy–Schwarz chain, and (iii) a *finite
  ratio of partition functions* `Z^(-)/Z`. The inequality itself is
  **cluster-expansion-free** — the strong-coupling expansion is only used
  afterwards to *evaluate* the ratio, not to *prove* the bound. This matches the
  RP + Cauchy–Schwarz machinery you already have landed.
- Keep exactly one low-priority KP job alive as a research item; do not gate the
  headline on it.

**Single highest-EV independent job per lane:**

- **C:** Formalize TY Theorem 1 (SU(2)/Z2 first) as a finite theorem
  `⟨W(C)⟩ ≤ 2·{ (1/2)(1 − Z_Λ^(−)/Z_Λ) }^{A_C/(L_μ L_ν)}`, derived from the
  landed connected Z2 Wilson-slab RP by iterated reflection. The corollary
  "rate = −log(base) > 0 whenever the box is BC-insensitive" then needs **no
  hard-coded constant**. (Then, separately, port to SU(2) via Theorem 2 below.)
- **T:** Finish Nielsen–Ninomiya *as the price of the turn* at determinant/topological
  level: the finite no-go that a local, hermitian, translation-invariant,
  chirally-symmetric free lattice Dirac operator has net-zero chirality over the
  Brillouin torus (sum of pole chiralities = 0), so a chirality-even (Wilson)
  term is *necessary* to lift doublers. This is the cleanest self-contained
  "mass = cost of the turn" theorem and it composes with the landed γ5 split.
- **A:** Prove the n-body `compositeMassSq` iff: `compositeMassSq = 0 ⟺ all
  momenta share a single null direction`, via the Gram-matrix / sum-of-pairwise-
  angles form. Unconditional finite linear algebra; it is the load-bearing content
  of lane A. Do this **before** the Plücker/`det P = m²` bridge (higher risk).

---

## Q2 — Biggest over-claim / semantic-alignment risk (beyond abelian characters)

**The word "gap" is overloaded, and "area law ≠ spectral mass gap ≠ Clay YM gap."**
Three distinct objects are all being labelled "the gap":
1. the Z2 sector transfer gap `−log(λ_flux/λ_0)`,
2. the TY area-law / vortex-free-energy bound,
3. the OS/GNS transfer-*Hamiltonian* spectral gap.
They are related but not identical. Bundling them under one "mass = cost of
closure" headline is the top equivocation risk. Concretely:

- **Almost the entire "closure" lane is really Z2/abelian, finite-volume,
  strong-coupling.** The flagged abelian-character issue is one instance of a
  *systematic pattern*, not an isolated bug: the SU(N) content is gestured at, not
  proved. Calling any of this "the SU(N) Yang–Mills mass gap" is the central
  over-claim.
- **No continuum limit, no volume independence.** A finite-lattice positive rate
  is not a mass gap in the Clay sense (which needs a limit with a gap bounded below
  *uniformly*). You already disclaim this — just make sure "origin of mass" in the
  headline cannot be read as implying it.
- **The taxonomy capstone (`AllMassFromNullEdges`) is a bundling/labelling
  theorem, not a derivation of mass.** "The three functionals are pairwise
  distinct" only says three definitions are unequal as functions; it does *not*
  establish that they are exhaustive, canonical, or physically the Higgs /
  confinement / kinematic masses. The functional→physics identification is
  interpretive. This is the biggest *headline* risk because it is where prose does
  the most work.
- **"Origin" implies necessity, not just non-vanishing.** For each leg the honest
  "origin" claim needs the *iff* (obstruction = 0 ⟺ massless/null), not merely an
  inequality or one direction. A's iff, T's no-go, and C's "positive rate ⟺ not
  BC-trivial" are what upgrade a "finite identity" to an "origin" statement.
  Current C results appear to give only one direction (gap-from-cost), not the
  converse.
- **Regulator leakage.** Keeping the Wilson/doubler mass in a separate row is
  correct, but the Wilson *action* underlies lane-C RP and the Wilson *term*
  underlies lane-T doubler removal. Audit that the "regulator mass" is not
  silently doing work that then gets credited to T or C.
- **Lane B:** the honest "co-location only" label is good; the live risk is later
  narration calling co-location a "derivation of the Standard Model."

---

## Q3 — Convergence: the smallest PROVED conjunction that honestly earns the headline

State the headline at the level the theorems support:
*"Three taxonomically-distinct, kernel-checked finite obstructions to null
transport — matter (T), gauge (C), kinematic (A) — each instantiated on finite
lattices/algebra."* For that, the minimal conjunction that must be **true and
proved** (not prose):

1. **(A)** `compositeMassSq ≥ 0`, `= 0 ⟺ single null direction` (n-body). *[closest to done]*
2. **(T)** chiral symmetry ⟹ no bare mass / forced doubling (Nielsen–Ninomiya,
   determinant level) **+** the γ5 turn-vertex split already landed, packaged so
   the turn *is* the obstruction (the iff/necessity direction).
3. **(C)** a single finite theorem: RP ⟹ (reflection/Cauchy–Schwarz) ⟹ area-law
   bound with a **strictly positive, proved** rate for at least one genuinely
   **nonabelian** group (SU(2)) at strong coupling — via TY, not KP. Positivity of
   the rate must be *proved*, not assumed.
4. **(X)** the three functionals are pairwise distinct **and** each is nonvacuous
   (a witness where it is nonzero while the other two vanish), so the taxonomy is
   not degenerate.
5. **(V)** an axiom guard on the *conjunction* capstone:
   `#print axioms` ⊆ `{propext, Classical.choice, Quot.sound}`.

**The single gate:** item 3 for a *nonabelian* group with a proven positive rate.
Everything else is landed or near. Until then the C-leg is Z2/abelian and the
honest headline is *"origin of matter and kinematic mass, plus an abelian model
of the gauge obstruction"* — not "origin of mass including gauge/confinement."

---

## Q4 — Literature (tools used: `curl` → arxiv.org / ar5iv.org, arXiv:0808.3442)

### (a) Precise Tomboulis–Yaffe inequality (formalizable without a memorized constant)

Wilson loop in irrep `R`: `W_R(C) = (1/d_R)·χ_R(∏_{b∈C} U_b)` (note: **normalized**
character — see (c)). `A_C` = minimal area spanned by loop `C`; `L_μ L_ν` =
transverse cross-sectional area of the box; `Z_Λ` = partition function with
periodic BC; `Z_Λ^{[k]}` = partition function with a `Z_N` 't Hooft twist / flux
`k` (`Z_Λ^(−)` = the twisted/antiperiodic one for SU(2)); `N(R)` = N-ality of `R`.

- **SU(2) (original TY, their eq. (4)):**
  `⟨W(C)⟩ ≤ 2·{ (1/2)·(1 − Z_Λ^(−)/Z_Λ) }^{ A_C/(L_μ L_ν) }`.

- **SU(N) (Kanazawa Thm 2, eqs. (26)–(28)):**
  `|⟨W_R(C)⟩| ≤ ⟨F^{[N(R)]}[V]⟩^{A_C/(L_μ L_ν)} + { 1 − ⟨F^{[0]}[V]⟩ }^{A_C/(L_μ L_ν)}`,
  and if `N(R) ≠ 0`,
  `|⟨W_R(C)⟩| ≤ 2·{ 1 − ⟨F^{[0]}[V]⟩ }^{A_C/(L_μ L_ν)}
             = 2·{ 1 − (1/N)·Σ_{k=0}^{N−1} Z_Λ^{[k]}/Z_Λ }^{A_C/(L_μ L_ν)}`.

- **Subgroup refinement (Kanazawa Thm 3):** for a center subgroup `Z_s ⊂ Z_N`,
  if `N(R) ≢ 0 (mod s)`:
  `|⟨W_R(C)⟩| ≤ 2·{ 1 − (1/s)·Σ_{k=0}^{s−1} Z_Λ^{[kN/s]}/Z_Λ }^{A_C/(L_μ L_ν)}`.

**Why this is ideal for Lean:** the "constant" is not memorized — it is the finite,
lattice-computable ratio `Z_Λ^{[k]}/Z_Λ` (equivalently the vortex/'t Hooft free
energy `−log(Z^{[k]}/Z)`). The bound is a pure RP + Cauchy–Schwarz consequence.
Taking `−(1/(L_μ L_ν))·log` of the base gives a string-tension / decay-rate lower
bound; "box insensitive to boundary conditions" means `Z^{[k]}/Z → 1`, driving the
base toward `0` and the rate up — the finite, kernel-checkable statement.

**Caveat to keep the label honest:** TY bounds the *Wilson-loop area law / string
tension* (a confinement statement), which is not literally the spectral gap of the
transfer Hamiltonian. Connect to the OS/transfer gap only through the separately
landed route; do not silently rename "area law" as "mass gap."

### (b) Other rigorous nonabelian-gap routes, ranked by Lean-tractability

1. **TY / 't Hooft vortex-free-energy (this paper) — most tractable.** RP +
   Cauchy–Schwarz only; no polymer/tree bounds. The pivot.
2. **Osterwalder–Seiler strong-coupling + transfer-matrix positivity**
   (Osterwalder–Seiler 1978; Seiler, *Gauge Theories as a Problem of Constructive
   QFT and Statistical Mechanics*, LNP 159). Convergent character/hopping
   expansion with simpler combinatorics than a full polymer expansion, plus a
   Perron–Frobenius/Simon–Lieb spectral-gap argument on the transfer matrix.
   Still an expansion, but lighter than KP.
3. **Reflection-positivity chessboard / infrared bounds**
   (Fröhlich–Simon–Spencer; Fröhlich–Israel–Lieb–Simon). Powerful but aimed at
   symmetry breaking / phase transitions, not directly a nonabelian gap — least fit
   for purpose here.

Net: nothing rigorous is *more* Lean-tractable than TY for a nonabelian gap; it is
the right target.

### (c) The abelian-only character-dominance issue: standard nonabelian fix

Yes — **use normalized characters** `w_R(g) := χ_R(g)/d_R = χ_R(g)/χ_R(1)`. For any
compact group and any g, `|χ_R(g)| ≤ χ_R(1) = d_R`, hence `|w_R(g)| ≤ 1` for *all*
irreps including nonabelian ones. (Reason: `χ_R(g) = tr ρ_R(g)` is a sum of `d_R`
eigenvalues each of modulus 1, so `|tr ρ_R(g)| ≤ d_R`; equality at `g = 1`.)
This is exactly the normalization TY uses: `W_R(C) = (1/d_R) χ_R(∏U_b)`. Replacing
the raw-character dominance lemma (which needed `‖χ_R‖ ≤ 1`, false for nonabelian
`d_R > 1`) by the normalized version repairs the SU(2)/SU(3) input. Citable
statement: `|χ_R(g)| ≤ dim R` (standard rep theory, e.g. Fulton–Harris,
*Representation Theory*; equivalently `|tr U| ≤ n` for `U ∈ U(n)`). Action item:
audit the Wilson-weight character expansion to ensure it is stated in normalized
characters throughout.
