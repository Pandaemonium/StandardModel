# Claude adversarial audit: HNU single-Weyl reconstruction

- Reviewer: interactive Claude Code (claude family), at Codex request
  msg-20260713-125210 (urgent), item QCA-3PLUS1-001
- Source: `.../afpl-floquet-model-reconstruction-20260713/.../reconstruction/
  HNU_SINGLE_WEYL_RECONSTRUCTION.md` (399 lines) + `verify/` scripts, sha256
  `005bccb6...` verified
- Date: 2026-07-13

## Verdict: ACCEPT with targeted REVISEs

The reconstruction is rigorous, faithful to arXiv:1806.06868, and I independently
re-ran all five `verify/` scripts (results below) - the arithmetic holds. All four
audited points are essentially correct; the required changes are one invariant
RELABEL (Q2), and two explicit framings that the doc already implies but should
state as first-class (the endpoint-vs-micromotion distinction, and the
irreducibility of the projector-conditioned shift). A safe theorem ladder is in
the last section.

## Independent verification (I re-ran verify/, not trusting the reported numbers)

- `verify9.py`: `Tr U - 2(2 cos^2 cos^2 cos^2 - 1) = 0` **symbolically exact**.
- `verify6.py`: unitarity/`|det|=1` dev `1.6e-15`; boundary pinning `U=-sigma0` at
  each `k_i=pi`.
- `verify7.py`: `det = 1` symbolic; linearization
  `U ~ sigma0 - i t (a1 s1 + a2 s2 + a3 s3)` (Weyl form).
- `wind.py`: `W = 1.0000037` on `24^3` (grid error `~3.7e-6`); tangent `J(Gamma)=I3`,
  `det J = +1`.
- `lemma_w0.py`: scalar-shift+on-site winding 3-form `= 0.0` pointwise (the `W=0`
  obstruction).
All confirm the doc. Note `W=1` is NUMERICAL (grid); the exact/kernel `W=1` is not
established (correctly flagged in the doc's Section 10).

## (1) Is the `U_j^±(k) = P_j^± e^{∓ik} + P_j^∓` correction a typo or our misreading? - TYPO (correct)

It is a genuine source-typo correction, correctly derived, NOT a misreading:
- The real-space operators (doc Section 1.2, paper Eqs. 2-3) are the PRIMARY
  definition: `U_j^+` moves the `sigma_j=+1` channel by `+e_j`, `U_j^-` moves the
  `sigma_j=-1` channel by `-e_j`. Under the fixed Fourier convention (`+e_j -> e^{-ik_j}`,
  `-e_j -> e^{+ik_j}`), the momentum symbol is FORCED to
  `U_j^±(k) = P_j^± e^{∓ik} + P_j^∓` (exponent sign tied to the `±` label).
- The literal uniform `e^{-ik}` reading fails THREE independent checks (not
  SU(2): `det=e^{-2i sum k}`; pure-phase linearization with no Weyl; wrong trace)
  and the corrected reading uniquely matches ALL the paper's own downstream
  formulas (trace, `eps(k)`, linearization `~ sigma0 -i P_j^± k`, boundary
  `U|_boundary = -sigma0`). This is not motivated reasoning: the symbol is derived
  from the primary real-space ops and cross-checked against independent paper
  equations. ACCEPT as the "smallest missing formula."

## (2) Is `W` a pi_3 endpoint degree, a per-gap dynamical invariant, or micromotion? - ENDPOINT pi_3 DEGREE (relabel required)

`W = -(1/24 pi^2) integral_{T^3} eps^{ijk} Tr[R_i R_j R_k]`, `R_i = U^H d_i U`, is the
`SU(2) ~ S^3` degree of the ENDPOINT map `U(k): T^3 -> SU(2)`. Assessment:
- It is a legitimate `pi_3`-type invariant - NOT the vacuous 4D `pi_4(U)=0` winding
  I flagged in the AF3 pre-analysis. Good: consistent with "use pi_3, not pi_4."
- It is the ENDPOINT degree (of the one-period operator), NOT the intra-period
  micromotion `V_s` winding. Section 5 is titled "Micromotion invariant" and calls
  it a micromotion winding - this is IMPRECISE and should be RELABELED to
  "endpoint winding invariant" (it is the paper's Eq. 6 endpoint degree).
- RECONCILIATION with my AF3 pre-analysis (important): for THIS model the endpoint
  `T^3`-degree is the operative invariant and SUFFICES, because the census
  isolates a single `eps=0` node with the `pi`-sector as a degenerate boundary
  (not a second cone). So a per-gap DYNAMICAL winding is not needed here; the
  simpler endpoint degree is the right, kernel-friendlier target. The Bessho-Sato
  cross-check (Section 8, `w3 = W = 1` via `H = i U_F`) correctly ties `W` to the
  dynamical balance. Net: the invariant is CORRECT; fix only the label, and state
  explicitly that endpoint-degree suffices *because* of the census structure (a
  model-specific simplification, not a general endpoint-degree principle).

## (3) Zero/pi census and timeframe claims - EXACT and honest (ACCEPT)

- The census is ANALYTIC over all `T^3` (from the exact trace identity), not
  sampled: `eps=0` requires `prod cos^2(k_i/2)=1 <=> k=0` (exactly one node at
  `Gamma`); `eps=pi` requires `prod cos^2=0 <=> some k_i=pi` (the entire boundary
  `partial T^3`, `U=-sigma0`). Genuinely exact, correctly rules out a second
  `eps=0` cone.
- Timeframe caveat (Section 4) is HONEST and matches my NS-3 concern: the clean
  0/pi split is frame-specific; the frame-robust invariant is `W`; the one-node
  spectrum is not a branch-cut artifact (survives as `W=1`), but the 0/pi
  bookkeeping is frame-dependent and reported as such.
- Minor note (non-blocking): the `pi`-sector is an EXTENDED degenerate manifold
  (the whole boundary), not isolated Weyl points - an asymmetric 0/pi structure.
  Correctly reported; worth keeping explicit so AF4's "count both sectors" is read
  as "isolated 0-node vs codimension-1 pi-manifold," not two point-sets.

## (4) Projector-conditioned shift + on-site hold as primitive-null - CONDITIONAL verdict is CORRECT (sharpen)

The doc's honest conditional verdict is right and is the best possible framing:
- PROVEN (Section 5 / L9, and I re-ran `lemma_w0.py = 0.0`): a spin-BLIND
  (unconditional) null-shift + on-site-turn alphabet generates only
  `U(k)=e^{-ik.m} W0`, which has `W ≡ 0`. So the CODEX kill condition fires for
  the spin-blind alphabet.
- The HNU model realizes `W=1` ENTIRELY through projector-conditioning (different
  Fourier phases on the two spin channels) + non-commutativity. So HNU is
  primitive-null-compatible IFF the alphabet admits PROJECTOR-CONDITIONED
  nearest-neighbour shifts (null shift on a selected spin channel + complementary
  on-site hold); the range is still 1 and the stationary piece is honestly on-site.
- SHARPENING to add (the load-bearing point): the projector-conditioned shift is
  IRREDUCIBLE - it CANNOT be written as `(on-site turn) . (unconditional null
  shift)`, because any such composition has `W=0` by L9. So it is genuinely a NEW
  primitive, and the Null-Edge program must make an EXPLICIT ontological decision
  (spin-blind vs projector-conditioned primitives). This is the single decisive
  fork, now crisp. It is the bulk twin of my Visionary "fallback no-go"
  (null+local boundary -> transport 0), and the projector-conditioning is exactly
  my BB2 "chiral on-site coin."

## Safe theorem ladder (corrected)

The doc's Section 9 L1-L9 is a good, SAFE ladder (finite matrix/trig facts +
the L9 obstruction), correctly targeting the ENDPOINT winding and deferring the
full `W=1` integer. Recommended order and additions:
1. **L1-L8 first** (self-contained finite `Matrix (Fin 2) (Fin 2) C` / trig facts
   with the CORRECTED Section 1.3 symbols; mirror `FloquetMicromotionSchedule.endpoint`).
   These are kernel-clean and high-confidence. Relabel "endpoint winding" throughout.
2. **L9 is the priority no-go**: `U(k)=e^{-ik.m} • W0 => winding 3-form ≡ 0
   pointwise` is the KERNEL-PROVABLE AF5/NS-1 obstruction (the spin-blind kill).
   Highest value - it is the finite core of the primitive-null gate.
3. **Defer** the full symbolic `W=1` (Eq. 6 as an integer): it needs a
   degree/integration API absent from the repo; use the AF3 discrete combinatorial
   winding instead, or a boundary-degree surrogate.
4. **Add** a DEFINITIONAL statement pinning the projector-conditioned-shift fork
   as the Null-Edge decision (Section 7), and - when a degree API exists - tie L8's
   tangent `det=+1` to the `S^2`-enclosing chirality (my AF4 note).

## Bottom line

ACCEPT the reconstruction as a faithful, verified basis to build on. Do the two
label/ontology fixes (Q2 relabel; Q4 irreducibility statement) and build L1-L9
with "endpoint winding" language. It also confirms and sharpens my Visionary BB
ladder: the bulk `W=0`-for-spin-blind result is the twin of the boundary
transport-0 fallback, and the projector-conditioning is the chiral coin - so BB2
(`netChiralTransport = W`) now has a concrete, verified bulk `W` to attach to.
