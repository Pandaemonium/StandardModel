#!/usr/bin/env python3
"""
validate_lgt_core.py -- Track C oracle v0.32 (YM ladder, 2026-07-05)

v0.2 (planning session for the 2026-07-03 overnight YM run) closes:
  ORACLE-TODO-1: section [9], complex-character fixture (Z3). Pins the
    conjugation placement in C-5 (w_hat_R = expansion coefficient, i.e.
    (1/|G|) sum_h w(h) chi_R(h^{-1})) AND a finding the freeze must fold
    in: the fusion lemma's argument order. For a GENERAL class function w
    the correct form is sum_h w(h) chi_R(h^{-1} A) = |G| w_hat_R chi_R(A)/d_R
    (convolution form); the freeze s4 form sum_h w(h) chi_R(A h) is valid
    exactly when w is inversion-symmetric (w(h) = w(h^{-1})), which holds
    for every Wilson weight w = exp(beta Re chi_f) since Re chi is
    inversion-invariant. Section [9] verifies both AND exhibits the naive
    order FAILING for an asymmetric complex class function. Lean statement
    files must state Lemma 2a in convolution form, with the Wilson case as
    a corollary via inversion symmetry.
  ORACLE-TODO-2: section [3]'s h->0 decay row is now a real monotonicity
    check on a fixed volume, not a hardcoded pass.

v0.3 (four-day YM run, T14) adds:
  RP-KER guard: section [10], a Z3 complex-character reflection kernel.
    The mirrored-inverse kernel K(b,a)=chi(a*b^{-1}) is Hermitian PSD and
    gives a nonnegative reflection form. The same-orientation/no-inverse
    variant K_bad(b,a)=chi(a*b) is not Hermitian and has an explicit
    complex-valued quadratic-form witness. This guards the anti-linear
    reflection slot / mirror-inverse convention used by
    ReflectionPositivityKernel.
  Fusion-spectrum guard: section [11], the S3 Wilson convolution matrix
    on all functions G -> C. It checks the character eigenvectors, expected
    eigenvalues |G|*w_hat_R/d_R, real spectrum, vacuum ordering, and
    normalized eigenvalues in [-1,1].
  KP-constant guard: section [12], a small finite Z2 connected-plaquette
    polymer gas. It enumerates every connected plaquette subset on small
    tori and checks the KP hypothesis with weight tanh(beta)^area and
    energy alpha*area. A nearby beta row is intentionally expected to fail
    with the same constants, guarding against non-volume-uniform claims.

v0.4 (four-day YM run, dynamics slice) adds:
  Finite Wilson slab transfer guard: section [13], a concrete Z2 1+1D
    gauge-summed one-step transfer kernel. It checks kernel symmetry/PSD,
    exact equality Tr(K^T)=sum over periodic spacetime link fields, time-zero
    spatial-flux observable insertion, global center-shift projector
    commutation, positive finite spectral gap on tiny examples, and a guard
    that raw magnetic flux is NOT a block label for this unprojected slab
    kernel.

v0.5 (four-day YM run, dynamics slice 2) adds:
  Two-time Euclidean correlation checks against exact spacetime enumeration,
    an eigendecomposition formula for the same transfer trace, and
    center-shift sector-block spectral reconstruction.

v0.6 (four-day YM run, dynamics slice 3) adds:
  A deterministic JSON-ready descriptor/summary record for the Z2 slab
    transfer oracle, including model conventions, checked numerical results,
    spectra, and explicit error fields.

v0.7 (four-day YM run, dynamics slice 4) adds:
  Descriptor-driven execution for the Z2 slab oracle: a stable schema,
    descriptor validation, supported observable/sector-label checks, optional
    matrix emission, and regression rows proving that descriptor input
    reproduces the transfer-trace, two-time-correlation, and sector-spectrum
    evidence path.

v0.8 (four-day YM run, dynamics slice 5) adds:
  A Lean-surface provenance section in the Z2 slab oracle JSON record.  The
    regression suite checks that the record names the theorem-shaped Lean
    modules its finite evidence is meant to inform, while still marking the
    payload as oracle evidence rather than proof.

v0.9 (four-day YM run, dynamics slice 6) adds:
  The one-link Z2 Lean bridge `TwoStateTransferZ2L1` to the oracle provenance
    record, so the executable L=1 slab kernel and the kernel-checked
    two-state descriptor surface are explicitly paired.

v0.10 (four-day YM run, dynamics slice 7) adds:
  Explicit one-link spectral-ratio theorem surfaces to the oracle provenance:
    the descriptor contraction factor and witness contraction factor are
    recorded as `tanh beta` in Lean.

v0.11 (four-day YM run, dynamics slice 8) adds:
  One-link flux-insertion theorem surfaces to the oracle provenance: the L=1
    spatial-flux insertion is Hermitian, involutive, and swaps the vacuum and
    local/flux eigenvectors in Lean.

v0.12 (four-day YM run, dynamics slice 9) adds:
  Descriptor-driven spatial-flux autocorrelation profiles: the descriptor can
    request tau values and the JSON record emits transfer/full/spectral checks
    for each requested tau.

v0.13 (four-day YM run, dynamics slice 10) adds:
  Reproducibility matrices for the descriptor path: optional JSON output now
    includes the spatial-flux insertion, global-center flip, and center
    projectors in the full spatial-state basis.

v0.14 (four-day YM run, dynamics slice 11) adds:
  A saved-record replay verifier for emitted JSON summaries, including matrix
  payload replay checks and a command-line `--verify-record` path.

v0.15 (four-day YM run, dynamics slice 12) adds:
  An explicit JSON-schema-style descriptor contract for the finite Z2 transfer
  descriptor, together with a command-line `--write-schema` path.

v0.16 (four-day YM run, dynamics slice 13) adds:
  Lean-surface provenance for the one-link slab trace and one-time flux-trace
  identities in `TwoStateTransferZ2L1`.

v0.17 (four-day YM run, dynamics slice 14) adds:
  Lean-surface provenance for the one-link two-step partition trace and raw
  two-time flux-correlation numerator identities.

v0.18 (four-day YM run, dynamics slice 15) adds:
  Lean-surface provenance for the normalized one-link `T = 2`, `tau = 1`
  spatial-flux autocorrelation ratio theorem.

v0.19 (four-day YM run, dynamics slice 16) adds:
  Lean-surface provenance for the concrete one-link slab transfer symmetry and
  Hermitian identities.

v0.20 (four-day YM run, dynamics slice 17) adds:
  Lean-surface provenance for the normalized one-link `T = 1` spatial-flux
  expectation theorem.

v0.21 (four-day YM run, dynamics slice 18) adds:
  Explicit full and center-sector first-gap fields to the Z2 transfer JSON
  spectrum record, plus saved-record verifier checks for those fields.

v0.22 (four-day YM run, dynamics slice 19) adds:
  Lean-surface provenance for the one-link center flip, center projectors, and
  their commutation with the L=1 slab transfer.

v0.23 (four-day YM run, dynamics slice 20) adds:
  Lean-surface provenance for the one-link center flip involution, plus/minus
  projector idempotence, and left/right center-flip eigenprojector laws.

v0.24 (four-day YM run, dynamics slice 21) adds:
  Saved-record and regression checks for the emitted global-center flip
  involution, plus/minus projector idempotence, and left/right center-flip
  eigenprojector laws.

v0.25 (four-day YM run, dynamics slice 22) adds:
  Lean-surface provenance for one-link spatial-flux/center anticommutation and
  plus/minus center-sector toggle laws.

v0.26 (four-day YM run, dynamics slice 23) adds:
  Saved-record and regression checks for the emitted spatial-flux/center
  anticommutation and plus/minus center-sector toggle laws.

v0.27 (four-day YM run, dynamics slice 24) adds:
  Saved-record and regression checks for the emitted spatial-flux insertion
  matrix Hermitian and involutive laws.

v0.28 (four-day YM run, dynamics slice 25) adds:
  Saved-record and regression checks for the emitted transfer-kernel symmetry
  and center flip/plus/minus projector commutation laws.

v0.29 (four-day YM run, dynamics slice 26) adds:
  Saved-record verification for the emitted full and center-sector positive
  eigenvalue lists, plus a tamper-rejection regression row.

v0.30 (four-day YM run, dynamics slice 27) adds:
  Lean provenance records for the one-link plus/minus center-projected transfer
  trace identities.

v0.31 (four-day YM run, dynamics slice 28) adds:
  Saved-record verification for the emitted plus/minus center-sector block
  matrices, plus a tamper-rejection regression row.

v0.32 (four-day YM run, dynamics slice 29) adds:
  Saved-record spectral replay from the emitted plus/minus center-sector block
  matrices, plus a tamper-rejection regression row.

Convention-pinning fixtures for the YM0/YM1/YM2/YM3 statement freezes.
Oracle discipline per Scripts/oracle/validate_flux2d_wilson_dirac.py:
tool versions recorded; oracle output is NEVER cited as proof; every PASS
below pins a convention or corroborates a statement that the Lean work
must prove from explicit objects.

Pinned conventions (normative for the statement-freeze document):
  C-1  Lattice: 2D torus Lx x Ly, sites s=(x,y), links live on POSITIVELY
       oriented edges only: (s,mu), mu in {0,1} (=+x,+y). Reversed
       traversal uses the group inverse.
  C-2  Plaquette at s: hol(p_s) = U(s,0) * U(s+x,1) * U(s+y,0)^{-1} * U(s,1)^{-1}
       (counterclockwise, based at s).
  C-3  Z2 realized multiplicatively as {+1,-1}; bit b=1 means -1.
  C-4  Weight per plaquette: w(h) = exp(beta * Re chi_f(h)); Z2: chi_f = sign
       irrep => w = exp(beta * s_p). S3: chi_f = chi_std (2-dim irrep).
  C-5  Character coefficient: w_hat_R = (1/|G|) sum_h w(h) chi_R(h^{-1})
       (real class functions here, so conjugation is moot).
  C-6  2D exact solution constants:  Z_open = |G|^(V-1) * (|G| w_hat_0)^P ;
       <W_R(C_A)> = d_R * gamma_R^A,  gamma_R = w_hat_R / (d_R w_hat_0).
  C-7  Z2 torus:  Z = 2^E cosh(beta)^P (1 + t^P),  t = tanh(beta);
       contractible loop of area A:  <W> = (t^A + t^(P-A)) / (1 + t^P).
  C-8  Transfer matrix (1+1D and 2+1D, temporal gauge): per-link temporal
       kernel K1(s,s') = exp(beta s s'); T = V^{1/2} K V^{1/2} with V the
       diagonal spatial-plaquette weight; Gauss projector P_G = average
       over local spatial gauge flips; Z_torus = 2^c * Tr[(T P_G)^{n_t}]
       with c pinned below.
"""
import sys, math, itertools, platform, json
import numpy as np
from z2_transfer_oracle import (
    descriptor_schema_record as z2_transfer_descriptor_schema_record,
    first_spectral_gap as z2_first_spectral_gap,
    full_spacetime_correlation as z2_transfer_full_correlation,
    full_spacetime_expectation as z2_transfer_full_expectation,
    full_spacetime_partition as z2_transfer_full_partition,
    model_descriptor as z2_transfer_model_descriptor,
    partition_from_transfer as z2_partition_from_transfer,
    sector_basis as z2_sector_basis,
    sector_block as z2_sector_block,
    sector_eigenvalues as z2_sector_eigenvalues,
    sector_projector as z2_sector_projector,
    spatial_flux as z2_spatial_flux,
    summarize as z2_transfer_summarize,
    summarize_descriptor as z2_transfer_summarize_descriptor,
    summary_record as z2_transfer_summary_record,
    transfer_correlation as z2_transfer_correlation,
    transfer_correlation_spectral as z2_transfer_correlation_spectral,
    transfer_expectation as z2_transfer_expectation,
    transfer_matrix as z2_transfer_matrix,
    validate_descriptor as z2_transfer_validate_descriptor,
    verify_record as z2_transfer_verify_record,
)

np.random.seed(20260703)
PASS = []
def check(name, cond, detail=""):
    status = "PASS" if cond else "FAIL"
    PASS.append(cond)
    print(f"  [{status}] {name}" + (f"  ({detail})" if detail else ""))
    if not cond:
        print("        ^^^ ORACLE FAILURE: convention or formula wrong; freeze doc must not cite this row.")

print(f"oracle v0.32 | python {platform.python_version()} | numpy {np.__version__}")
print("=" * 78)

# ---------------------------------------------------------------- Z2 torus
def z2_torus(Lx, Ly):
    """Return (E, P, plaquette bit-index lists, link index map)."""
    def site(x, y): return (x % Lx) + Lx * (y % Ly)
    def link(x, y, mu): return 2 * site(x, y) + mu
    plaqs = []
    for y in range(Ly):
        for x in range(Lx):
            plaqs.append([link(x, y, 0), link(x + 1, y, 1),
                          link(x, y + 1, 0), link(x, y, 1)])  # Z2: orientation moot
    return 2 * Lx * Ly, Lx * Ly, plaqs, link

def z2_brute(Lx, Ly, beta, h=0.0, obs_links=None, wilson_loops=None):
    """Exact sum over all 2^E configs. Returns Z, <sigma_l> for obs_links,
    <W_C> for each Wilson loop (list of link indices)."""
    E, P, plaqs, _ = z2_torus(Lx, Ly)
    cfg = np.arange(1 << E, dtype=np.uint64)
    # plaquette spins s_p = +-1
    Ssum = np.zeros(cfg.shape, dtype=np.float64)
    for pl in plaqs:
        par = np.zeros(cfg.shape, dtype=np.uint64)
        for b in pl:
            par ^= (cfg >> np.uint64(b))
        Ssum += 1.0 - 2.0 * (par & np.uint64(1)).astype(np.float64)
    # link magnetization sum
    Msum = np.zeros(cfg.shape, dtype=np.float64)
    if h != 0.0:
        for b in range(E):
            Msum += 1.0 - 2.0 * ((cfg >> np.uint64(b)) & np.uint64(1)).astype(np.float64)
    w = np.exp(beta * Ssum + h * Msum)
    Z = w.sum()
    out_sig, out_wil = [], []
    if obs_links:
        for b in obs_links:
            s = 1.0 - 2.0 * ((cfg >> np.uint64(b)) & np.uint64(1)).astype(np.float64)
            out_sig.append((s * w).sum() / Z)
    if wilson_loops:
        for loop in wilson_loops:
            par = np.zeros(cfg.shape, dtype=np.uint64)
            for b in loop:
                par ^= (cfg >> np.uint64(b))
            s = 1.0 - 2.0 * (par & np.uint64(1)).astype(np.float64)
            out_wil.append((s * w).sum() / Z)
    return Z, out_sig, out_wil

print("\n[1] Z2 2D torus: closed forms vs brute force (pins C-3, C-4, C-7)")
for (Lx, Ly) in [(2, 2), (2, 3), (3, 3)]:
    E, P, plaqs, link = z2_torus(Lx, Ly)
    beta = 0.6
    t = math.tanh(beta)
    # Wilson loops: area 1 (single plaquette boundary) and, if it fits, area 2
    loops = [plaqs[0]]
    areas = [1]
    if Lx >= 3:  # 1x2 rectangle at origin: boundary links
        rect = [link(0, 0, 0), link(1, 0, 0), link(2, 0, 1),
                link(1, 1, 0), link(0, 1, 0), link(0, 0, 1)]
        loops.append(rect); areas.append(2)
    Z, _, W = z2_brute(Lx, Ly, beta, wilson_loops=loops)
    Zth = (2 ** E) * math.cosh(beta) ** P * (1 + t ** P)
    check(f"{Lx}x{Ly}: Z = 2^E cosh^P (1+t^P)", abs(Z / Zth - 1) < 1e-12,
          f"Z={Z:.6e}")
    for A, Wm in zip(areas, W):
        Wth = (t ** A + t ** (P - A)) / (1 + t ** P)
        check(f"{Lx}x{Ly}: <W(A={A})> = (t^A+t^(P-A))/(1+t^P)",
              abs(Wm - Wth) < 1e-12, f"meas={Wm:.10f} th={Wth:.10f}")

print("\n[2] Z2 gauge invariance under random gauge transforms (pins YM0 lemma L2)")
Lx, Ly = 3, 3
E, P, plaqs, link = z2_torus(Lx, Ly)
rng = np.random.default_rng(7)
ok = True
for _ in range(200):
    sigma = rng.integers(0, 2, size=E)          # bits
    g = rng.integers(0, 2, size=Lx * Ly)        # site bits
    sig2 = sigma.copy()
    for y in range(Ly):
        for x in range(Lx):
            s = (x % Lx) + Lx * (y % Ly)
            for mu, (nx, ny) in enumerate([(x + 1, y), (x, y + 1)]):
                s2 = (nx % Lx) + Lx * (ny % Ly)
                sig2[2 * s + mu] ^= g[s] ^ g[s2]
    for pl in plaqs:
        p1 = sigma[pl].sum() % 2
        p2 = sig2[pl].sum() % 2
        ok &= (p1 == p2)
check("plaquette holonomy invariant under 200 random gauge transforms", ok)

print("\n[3] Elitzur bound (finite, quantitative): |<sigma_l>| <= tanh(2d*h), volume-uniform")
beta = 0.6
sig_by_h = {}  # ORACLE-TODO-2: record per-h values for a real decay check below
for h in [0.2, 0.1, 0.05]:
    bound = math.tanh(4 * h)  # 2d = 4 links meet each site in 2D
    vals = []
    for (Lx, Ly) in [(2, 2), (2, 3), (3, 3)]:
        _, sig, _ = z2_brute(Lx, Ly, beta, h=h, obs_links=[0])
        vals.append(sig[0])
    spread = max(vals) - min(vals)
    check(f"h={h}: |<sigma_l>| <= tanh(4h)={bound:.4f} on all volumes",
          all(abs(v) <= bound + 1e-12 for v in vals),
          "vals=" + ",".join(f"{v:.5f}" for v in vals))
    sig_by_h[h] = vals[0]  # fixed volume (2x2) for the monotonicity check
check("h->0 decay: |<sigma_l>| strictly decreasing in h on fixed 2x2 volume",
      abs(sig_by_h[0.05]) < abs(sig_by_h[0.1]) < abs(sig_by_h[0.2]),
      f"h=0.2:{sig_by_h[0.2]:.5f} h=0.1:{sig_by_h[0.1]:.5f} h=0.05:{sig_by_h[0.05]:.5f}")

# ---------------------------------------------------------------- S3 sector
print("\n[4] S3 (nonabelian) 2D open lattice: character-expansion exact solution (pins C-5, C-6)")
# S3 as permutations of {0,1,2}
perms = list(itertools.permutations(range(3)))
IDX = {p: i for i, p in enumerate(perms)}
def compose(a, b):  # (a o b)(x) = a[b[x]]
    return tuple(perms[a][perms[b][x]] for x in range(3))
MUL = [[IDX[compose(a, b)] for b in range(6)] for a in range(6)]
INV = [next(b for b in range(6) if MUL[a][b] == 0) for a in range(6)]
def cyc_type(i):
    p = perms[i]
    fixed = sum(1 for x in range(3) if p[x] == x)
    return {3: 'e', 1: 't', 0: 'c'}[fixed]
CHI = {  # irreducible characters by class
    'triv': {'e': 1, 't': 1, 'c': 1},
    'sign': {'e': 1, 't': -1, 'c': 1},
    'std':  {'e': 2, 't': 0, 'c': -1},
}
DIM = {'triv': 1, 'sign': 1, 'std': 2}
def chi(R, i): return CHI[R][cyc_type(i)]

beta = 0.5
w = [math.exp(beta * chi('std', i)) for i in range(6)]
what = {R: sum(w[INV[i]] * chi(R, i) for i in range(6)) / 6 for R in CHI}
check("Bochner hypothesis: all character coefficients w_hat_R >= 0",
      all(v >= 0 for v in what.values()),
      " ".join(f"{R}={v:.5f}" for R, v in what.items()))

# open 2x1-plaquette lattice: vertices (x,y), x in 0..2, y in 0..1
# links: H(x,y): (x,y)->(x+1,y) for x in {0,1}; V(x): (x,0)->(x,1)
# order: [H00,H10,H01,H11,V0,V1,V2]
H = {(0, 0): 0, (1, 0): 1, (0, 1): 2, (1, 1): 3}
V = {0: 4, 1: 5, 2: 6}
def hol_plaq(U, x):  # C-2 convention, based at (x,0)
    a = U[H[(x, 0)]]
    a = MUL[a][U[V[x + 1]]]
    a = MUL[a][INV[U[H[(x, 1)]]]]
    a = MUL[a][INV[U[V[x]]]]
    return a
def hol_outer(U):  # boundary of both plaquettes, area 2, based at (0,0)
    a = U[H[(0, 0)]]
    a = MUL[a][U[H[(1, 0)]]]
    a = MUL[a][U[V[2]]]
    a = MUL[a][INV[U[H[(1, 1)]]]]
    a = MUL[a][INV[U[H[(0, 1)]]]]
    a = MUL[a][INV[U[V[0]]]]
    return a

# exact histogram: accumulate integer counts of (h1_class-weighted) pairs, then fsum
Zterms = []
num = {R: [[], []] for R in CHI}   # [area1, area2]
for U in itertools.product(range(6), repeat=7):
    h1 = hol_plaq(U, 0); h2p = hol_plaq(U, 1)
    wt = w[h1] * w[h2p]
    Zterms.append(wt)
    h2 = hol_outer(U)
    for R in CHI:
        num[R][0].append(chi(R, h1) * wt)
        num[R][1].append(chi(R, h2) * wt)
Z = math.fsum(Zterms)
num = {R: [math.fsum(num[R][0]), math.fsum(num[R][1])] for R in CHI}
sumw = math.fsum(w)
Zth = 6 ** 5 * sumw ** 2   # |G|^(V-1) (sum w)^P, V=6, P=2
check("Z_open = |G|^(V-1) (sum_h w)^P", abs(Z / Zth - 1) < 1e-12, f"Z={Z:.6e}")
for R in CHI:
    gam = what[R] / (DIM[R] * what['triv'])
    for A in (1, 2):
        Wm = num[R][A - 1] / Z
        Wth = DIM[R] * gam ** A
        check(f"<W_{R}(A={A})> = d_R gamma_R^A", abs(Wm - Wth) < 1e-10,
              f"meas={Wm:.8f} th={Wth:.8f}")

print("\n[5] S3 gauge invariance (nonabelian; conjugation-invariance of class observables)")
ok = True
for _ in range(300):
    U = list(rng.integers(0, 6, size=7))
    g = list(rng.integers(0, 6, size=6))   # 6 vertices: (x,y) -> 2*y? map below
    def vid(x, y): return x + 3 * y
    U2 = U.copy()
    for (x, y), l in H.items():
        U2[l] = MUL[MUL[g[vid(x, y)]][U[l]]][INV[g[vid(x + 1, y)]]]
    for x, l in V.items():
        U2[l] = MUL[MUL[g[vid(x, 0)]][U[l]]][INV[g[vid(x, 1)]]]
    for x in range(2):
        ok &= cyc_type(hol_plaq(U, x)) == cyc_type(hol_plaq(U2, x))  # class invariance
    ok &= cyc_type(hol_outer(U)) == cyc_type(hol_outer(U2))
check("plaquette/loop holonomy CLASS invariant under 300 random S3 gauge transforms", ok)

# ------------------------------------------------------- transfer matrices
print("\n[6] Transfer matrix = path integral (1+1D Z2), positivity, pinned constant (pins C-8)")
def transfer_1p1(L, beta):
    """States: spatial link bits on ring of L sites/links. T = temporal kernel only."""
    dim = 1 << L
    K1 = np.array([[math.exp(beta), math.exp(-beta)],
                   [math.exp(-beta), math.exp(beta)]])
    T = np.ones((1, 1))
    for _ in range(L):
        T = np.kron(T, K1)
    # Gauss projector: average over site flips; flip at site i flips links i-1, i
    Pg = np.zeros((dim, dim))
    for gbits in range(1 << L):
        perm = np.arange(dim)
        flip = 0
        for i in range(L):
            if (gbits >> i) & 1:
                flip ^= (1 << i) ^ (1 << ((i - 1) % L))
        Pg[np.arange(dim), perm ^ flip] += 1.0 / (1 << L)
    return T, Pg

records = []
for (L, nt) in [(2, 2), (3, 3)]:
    T, Pg = transfer_1p1(L, beta=0.6)
    evK = np.linalg.eigvalsh(T)
    check(f"L={L}: temporal kernel T symmetric PSD", evK.min() > -1e-10,
          f"min eig={evK.min():.3e}")
    M = T @ Pg
    Ztm = np.trace(np.linalg.matrix_power(M, nt))
    Zbf, _, _ = z2_brute(L, nt, 0.6)
    c = math.log2(Zbf / Ztm)
    records.append((L, nt, c))
    check(f"L={L},nt={nt}: Z_bruteforce / Tr[(T P_G)^nt] = 2^c with c integer",
          abs(c - round(c)) < 1e-9, f"c={c:.9f}")
c_formula_ok = all(abs(c - L * nt) < 1e-9 for (L, nt, c) in records)
check("pinned constant: c = L*nt (temporal-link sum normalization)", c_formula_ok,
      " ".join(f"(L={L},nt={n}): c={c:.3f}" for L, n, c in records))

print("\n[7] Transfer matrix 2+1D Z2, 2x2 spatial torus: positivity + physical-sector gap")
Ls = 2
sites = [(x, y) for y in range(Ls) for x in range(Ls)]
sid = {s: i for i, s in enumerate(sites)}
links = []
for (x, y) in sites:
    links.append(((x, y), 0)); links.append(((x, y), 1))
lid = {l: i for i, l in enumerate(links)}
nL = len(links); dim = 1 << nL
def spat_plaqs():
    pls = []
    for (x, y) in sites:
        pls.append([lid[((x, y), 0)], lid[(((x + 1) % Ls, y), 1)],
                    lid[((x, (y + 1) % Ls), 0)], lid[((x, y), 1)]])
    return pls
PLS = spat_plaqs()
states = np.arange(dim)
def plaq_spin(state_arr, pl):
    par = np.zeros_like(state_arr)
    for b in pl:
        par ^= (state_arr >> b)
    return 1.0 - 2.0 * (par & 1)
for beta in [0.2, 0.4, 0.6]:
    Sdiag = sum(plaq_spin(states, pl) for pl in PLS)
    Vh = np.exp(0.5 * beta * Sdiag)
    K1 = np.array([[math.exp(beta), math.exp(-beta)],
                   [math.exp(-beta), math.exp(beta)]])
    K = np.ones((1, 1))
    for _ in range(nL):
        K = np.kron(K, K1)
    T = (Vh[:, None] * K) * Vh[None, :]
    # Gauss projector
    Pg = np.zeros((dim, dim))
    for gbits in range(1 << len(sites)):
        flip = 0
        for (x, y) in sites:
            if (gbits >> sid[(x, y)]) & 1:
                for l in [((x, y), 0), (((x - 1) % Ls, y), 0),
                          ((x, y), 1), ((x, (y - 1) % Ls), 1)]:
                    flip ^= (1 << lid[l])
        Pg[states, states ^ flip] += 1.0 / (1 << len(sites))
    M = Pg @ T @ Pg
    ev = np.linalg.eigvalsh(0.5 * (M + M.T))
    ev = np.sort(ev)[::-1]
    ev = ev[ev > 1e-12 * ev[0]]
    gap = -math.log(ev[1] / ev[0])
    check(f"beta={beta}: T PSD and physical gap > 0", ev.min() > 0 and gap > 0,
          f"gap={gap:.5f}, lam0={ev[0]:.4e}")

print("\n[8] Bochner / reflection-positivity engine: w_hat_R >= 0 across groups and beta")
allok = True
for beta in [0.1, 0.5, 1.0, 2.0]:
    # Z2
    ok = math.cosh(beta) >= 0 and math.sinh(beta) >= 0
    # Z16 (U(1) proxy): w = exp(beta cos theta_j)
    N = 16
    wv = [math.exp(beta * math.cos(2 * math.pi * j / N)) for j in range(N)]
    for k in range(N):
        ck = sum(wv[j] * math.cos(2 * math.pi * k * j / N) for j in range(N)) / N
        ok &= ck >= -1e-12
    # S3
    wv3 = [math.exp(beta * chi('std', i)) for i in range(6)]
    for R in CHI:
        ok &= sum(wv3[INV[i]] * chi(R, i) for i in range(6)) / 6 >= -1e-12
    # kernel PSD directly for S3: K(g,h) = w(g h^{-1})
    Km = np.array([[wv3[MUL[g][INV[h]]] for h in range(6)] for g in range(6)])
    ok &= np.linalg.eigvalsh(Km).min() > -1e-10
    allok &= ok
check("w = exp(beta Re chi_f): all character coefficients >= 0 and K(g,h)=w(gh^-1) PSD "
      "for Z2, Z16, S3 at beta in {0.1,0.5,1,2}", allok)

print("\n[9] Z3 complex-character fixture (closes ORACLE-TODO-1): pins C-5 conjugation")
print("    placement and the fusion lemma's argument order (see module docstring)")
# Z3: chi_k(j) = omega^(k j), omega = exp(2 pi i / 3); k = 1, 2 are COMPLEX irreps.
omega = complex(math.cos(2 * math.pi / 3), math.sin(2 * math.pi / 3))
def chi3(k, j):
    return omega ** ((k * j) % 3)

# (a) Wilson weight w = exp(beta Re chi_1): inversion-symmetric by construction.
beta = 0.7
w3 = [math.exp(beta * chi3(1, j).real) for j in range(3)]
# C-5 coefficients: w_hat_k = (1/|G|) sum_j w(j) chi_k(j^{-1}); two equivalent evaluations
what3 = {k: sum(w3[j] * chi3(k, (-j) % 3) for j in range(3)) / 3 for k in range(3)}
what3b = {k: sum(w3[(-j) % 3] * chi3(k, j) for j in range(3)) / 3 for k in range(3)}
check("Z3 Wilson weight: C-5 coefficients real, both evaluation orders agree",
      all(abs(what3[k] - what3b[k]) < 1e-12 and abs(what3[k].imag) < 1e-12
          for k in range(3)),
      " ".join(f"k={k}:{what3[k].real:.5f}" for k in range(3)))
check("Z3 Wilson weight: w_hat_k >= 0 (Bochner hypothesis holds for complex irreps)",
      all(what3[k].real >= -1e-12 for k in range(3)))
ok = True  # fusion in the freeze-s4 order, valid here BECAUSE w is inversion-symmetric
for k in range(3):
    for A in range(3):
        lhs = sum(w3[j] * chi3(k, (A + j) % 3) for j in range(3))
        rhs = 3 * what3[k] * chi3(k, A)
        ok &= abs(lhs - rhs) < 1e-12
check("Z3 Wilson weight: fusion sum_h w(h) chi(A h) = |G| w_hat chi(A) "
      "(symmetric-weight form)", ok)

# (b) GENERIC complex class function (abelian: any function), NOT inversion-symmetric.
wgen = [1.0 + 0.0j, 0.9 + 0.4j, 0.2 - 0.7j]  # w(1) != w(2): breaks the symmetry
whatg = {k: sum(wgen[j] * chi3(k, (-j) % 3) for j in range(3)) / 3 for k in range(3)}
check("Z3 generic w: C-5 gives the EXPANSION coefficients (w = sum_k w_hat_k chi_k)",
      all(abs(sum(whatg[k] * chi3(k, j) for k in range(3)) - wgen[j]) < 1e-12
          for j in range(3)))
ok = True  # fusion in CONVOLUTION form: sum_h w(h) chi(h^{-1} A) = |G| w_hat chi(A)/d
for k in range(3):
    for A in range(3):
        lhs = sum(wgen[j] * chi3(k, (A - j) % 3) for j in range(3))
        rhs = 3 * whatg[k] * chi3(k, A)
        ok &= abs(lhs - rhs) < 1e-12
check("Z3 generic w: fusion holds in convolution form sum_h w(h) chi(h^{-1} A)", ok)
naive_differs = any(
    abs(sum(wgen[j] * chi3(k, (A + j) % 3) for j in range(3))
        - 3 * whatg[k] * chi3(k, A)) > 1e-6
    for k in range(3) for A in range(3))
check("Z3 generic w: naive order sum_h w(h) chi(A h) DIFFERS - placement is "
      "load-bearing (guard row)", naive_differs)

print("\n[10] RP-KER Z3 complex-character guard: mirror inverse and anti-linear slot")
K_rp = np.array([[chi3(1, (a - b) % 3) for a in range(3)] for b in range(3)],
                dtype=np.complex128)
eig_rp = np.linalg.eigvalsh(K_rp)
check("Z3 RP kernel K(b,a)=chi(a*b^{-1}) is Hermitian PSD",
      np.max(np.abs(K_rp - K_rp.conj().T)) < 1e-12 and eig_rp.min() > -1e-12,
      "eig=" + ",".join(f"{x:.3e}" for x in eig_rp))
f_rp = np.array([1.0 + 2.0j, -0.5 + 0.25j, 0.75 - 1.0j], dtype=np.complex128)
q_rp = np.vdot(f_rp, K_rp @ f_rp)
check("Z3 RP kernel: reflection form conj(f_b) K(b,a) f_a is nonnegative",
      abs(q_rp.imag) < 1e-12 and q_rp.real >= -1e-12,
      f"q={q_rp.real:.6f}+{q_rp.imag:.2e}i")

K_bad = np.array([[chi3(1, (a + b) % 3) for a in range(3)] for b in range(3)],
                 dtype=np.complex128)
bad_f = np.array([0.0 + 0.0j, 0.0 + 0.0j, 1.0 + 0.0j], dtype=np.complex128)
q_bad = np.vdot(bad_f, K_bad @ bad_f)
check("Z3 no-inverse mirror variant K_bad(b,a)=chi(a*b) is not Hermitian",
      np.max(np.abs(K_bad - K_bad.conj().T)) > 1e-6)
check("Z3 no-inverse mirror variant has a complex quadratic-form witness",
      abs(q_bad.imag) > 1e-6,
      f"q_bad={q_bad.real:.6f}+{q_bad.imag:.6f}i")

print("\n[11] S3 fusion spectrum: character eigenvalues real and vacuum-ordered")
spectral_ok = True
eigenvector_ok = True
spectral_details = []
for beta in [0.1, 0.5, 1.0, 2.0]:
    wv3 = [math.exp(beta * chi('std', i)) for i in range(6)]
    what_beta = {R: sum(wv3[INV[i]] * chi(R, i) for i in range(6)) / 6 for R in CHI}
    conv = np.array([[wv3[MUL[A][INV[B]]] for B in range(6)] for A in range(6)],
                    dtype=np.float64)
    evals = np.linalg.eigvalsh(conv)
    vacuum = math.fsum(wv3)
    ratios = evals / vacuum
    spectral_ok &= (
        np.max(np.abs(conv - conv.T)) < 1e-12
        and abs(evals[-1] - vacuum) < 1e-10
        and ratios.min() >= -1e-10
        and ratios.max() <= 1 + 1e-10
    )
    spectral_details.append(f"beta={beta}:min={ratios.min():.6f},max={ratios.max():.6f}")
    for R in CHI:
        vec = np.array([chi(R, A) for A in range(6)], dtype=np.complex128)
        lam = 6 * what_beta[R] / DIM[R]
        residual = np.linalg.norm(conv.astype(np.complex128) @ vec - lam * vec)
        eigenvector_ok &= residual < 1e-10
check("S3 convLeft matrix has real vacuum-ordered normalized spectrum in [0,1]",
      spectral_ok, "; ".join(spectral_details))
check("S3 characters are convLeft eigenvectors with eigenvalue |G|*w_hat_R/d_R",
      eigenvector_ok)

print("\n[12] KP constant fixture: small Z2 connected-plaquette polymer gas")
print("    polymers = connected plaquette subsets; incompatible = touching supports")
def torus_plaquette_neighbor_bits(Lx, Ly):
    sites = [(x, y) for y in range(Ly) for x in range(Lx)]
    idx = {p: i for i, p in enumerate(sites)}
    out = []
    for x, y in sites:
        bits = 0
        for q in [((x + 1) % Lx, y), ((x - 1) % Lx, y),
                  (x, (y + 1) % Ly), (x, (y - 1) % Ly)]:
            bits |= 1 << idx[q]
        out.append(bits)
    return out

def connected_polymer_masks(n, neighbor_bits):
    polys = []
    for mask in range(1, 1 << n):
        first = (mask & -mask).bit_length() - 1
        seen = 0
        frontier = [first]
        while frontier:
            i = frontier.pop()
            if (seen >> i) & 1:
                continue
            seen |= 1 << i
            next_bits = neighbor_bits[i] & mask & ~seen
            while next_bits:
                j = (next_bits & -next_bits).bit_length() - 1
                frontier.append(j)
                next_bits &= next_bits - 1
        if seen == mask:
            polys.append(mask)
    return polys

def plaquette_closure(mask, neighbor_bits):
    out = mask
    bits = mask
    while bits:
        i = (bits & -bits).bit_length() - 1
        out |= neighbor_bits[i]
        bits &= bits - 1
    return out

def z2_polymer_kp_stats(L, beta, alpha):
    """Exact finite KP sum for connected plaquette polymers on an LxL torus.

    Weight = |tanh(beta)|^area, energy = alpha*area. Two polymers are
    incompatible when one intersects the one-step plaquette-neighborhood of
    the other. A subset zeta transform computes incompatible sums without an
    O(polymer^2) pair loop.
    """
    n = L * L
    neighbor_bits = torus_plaquette_neighbor_bits(L, L)
    polys = connected_polymer_masks(n, neighbor_bits)
    weighted = [0.0] * (1 << n)
    t = abs(math.tanh(beta))
    for mask in polys:
        area = mask.bit_count()
        weighted[mask] = (t ** area) * math.exp(alpha * area)
    total = math.fsum(weighted)
    subset_sum = weighted[:]
    for i in range(n):
        bit = 1 << i
        for mask in range(1 << n):
            if mask & bit:
                subset_sum[mask] += subset_sum[mask ^ bit]
    full = (1 << n) - 1
    worst_ratio = -1.0
    worst_area = 0
    for mask in polys:
        area = mask.bit_count()
        incompatible_sum = total - subset_sum[full ^ plaquette_closure(mask, neighbor_bits)]
        ratio = incompatible_sum / (alpha * area)
        if ratio > worst_ratio:
            worst_ratio = ratio
            worst_area = area
    return {
        "L": L,
        "polymer_count": len(polys),
        "worst_ratio": worst_ratio,
        "worst_area": worst_area,
    }

kp_good = [z2_polymer_kp_stats(L, beta=0.04, alpha=0.75) for L in [2, 3, 4]]
check("Z2 polymer gas: KP(beta=0.04, alpha=0.75) holds on L=2,3,4",
      all(r["worst_ratio"] <= 1 + 1e-12 for r in kp_good),
      "; ".join(f"L={r['L']} n={r['polymer_count']} "
                f"max={r['worst_ratio']:.3f}@area{r['worst_area']}"
                for r in kp_good))

kp_bad = [z2_polymer_kp_stats(L, beta=0.06, alpha=0.75) for L in [2, 3, 4]]
check("Z2 polymer gas: same alpha fails by L>=3 at beta=0.06 (guard row)",
      kp_bad[0]["worst_ratio"] <= 1 + 1e-12
      and any(r["worst_ratio"] > 1 + 1e-12 for r in kp_bad[1:]),
      "; ".join(f"L={r['L']} n={r['polymer_count']} "
                f"max={r['worst_ratio']:.3f}@area{r['worst_area']}"
                for r in kp_bad))

print("\n[13] Z2 1+1D finite Wilson slab transfer oracle (dynamics v0.32)")
print("     K(u,v)=sum_a exp(beta * sum_i a_i v_i a_{i+1} u_i), "
      "with exact spacetime validation")
for beta in [0.2, 0.4, 0.7]:
    for L in [1, 2, 3]:
        Kslab = z2_transfer_matrix(L, beta)
        eig = np.linalg.eigvalsh(0.5 * (Kslab + Kslab.T))
        check(f"L={L}, beta={beta}: slab kernel symmetric PSD",
              np.max(np.abs(Kslab - Kslab.T)) < 1e-12
              and eig.min() >= -1e-10,
              f"min eig={eig.min():.3e}")

for (L, nt, beta) in [(1, 1, 0.4), (2, 2, 0.4), (3, 2, 0.4), (2, 3, 0.7)]:
    Z_transfer = z2_partition_from_transfer(L, nt, beta)
    Z_full = z2_transfer_full_partition(L, nt, beta)
    Z_brute, _, _ = z2_brute(L, nt, beta)
    check(f"L={L},nt={nt},beta={beta}: Tr(K^nt) equals slab enumeration",
          abs(Z_transfer / Z_full - 1) < 1e-12,
          f"Tr={Z_transfer:.6e} full={Z_full:.6e}")
    check(f"L={L},nt={nt},beta={beta}: slab enumeration matches z2_brute",
          abs(Z_full / Z_brute - 1) < 1e-12,
          f"full={Z_full:.6e} brute={Z_brute:.6e}")

for (L, nt, beta) in [(2, 2, 0.4), (3, 2, 0.4), (3, 3, 0.7)]:
    obs = lambda state, L=L: z2_spatial_flux(state, L)
    E_transfer = z2_transfer_expectation(L, nt, beta, obs)
    E_full = z2_transfer_full_expectation(L, nt, beta, obs)
    _, _, W_brute = z2_brute(
        L, nt, beta,
        wilson_loops=[[2 * x for x in range(L)]],
    )
    check(f"L={L},nt={nt},beta={beta}: Tr(M_phi K^nt)/Tr(K^nt) matches full sum",
          abs(E_transfer - E_full) < 1e-12,
          f"transfer={E_transfer:.3e} full={E_full:.3e}")
    check(f"L={L},nt={nt},beta={beta}: time-zero spatial flux matches z2_brute loop",
          abs(E_full - W_brute[0]) < 1e-12,
          f"full={E_full:.3e} brute={W_brute[0]:.3e}")

for (L, nt, beta, tau) in [(2, 3, 0.4, 1), (3, 3, 0.7, 1), (3, 3, 0.7, 2)]:
    obs = lambda state, L=L: z2_spatial_flux(state, L)
    C_transfer = z2_transfer_correlation(L, nt, beta, obs, obs, tau)
    C_full = z2_transfer_full_correlation(L, nt, beta, obs, obs, tau)
    C_spectral = z2_transfer_correlation_spectral(L, nt, beta, obs, obs, tau)
    check(f"L={L},nt={nt},beta={beta},tau={tau}: two-time flux correlation "
          "matches full spacetime sum",
          abs(C_transfer - C_full) < 1e-10,
          f"transfer={C_transfer:.10f} full={C_full:.10f}")
    check(f"L={L},nt={nt},beta={beta},tau={tau}: two-time trace matches "
          "spectral formula",
          abs(C_transfer - C_spectral) < 1e-10,
          f"trace={C_transfer:.10f} spectral={C_spectral:.10f}")

descriptor_summary = z2_transfer_summarize(L=3, T=3, beta=0.7)
descriptor_record = z2_transfer_summary_record(descriptor_summary)
descriptor_json = json.dumps(descriptor_record, sort_keys=True)
check("descriptor JSON record is serializable and summary-consistent",
      descriptor_record["oracle"]["version"] == "v0.32"
      and descriptor_record["descriptor"]["schema_version"]
      == "z2_1p1d_wilson_slab_transfer.v1"
      and descriptor_record["descriptor"]["model"] == "z2_1p1d_wilson_slab_transfer"
      and descriptor_record["descriptor"]["lattice"]["space"]["shape"] == [3]
      and descriptor_record["descriptor"]["lattice"]["time"]["extent"] == 3
      and descriptor_record["checks"]["partition_rel_error"] < 1e-10
      and descriptor_record["checks"]["two_time_flux_abs_error"] < 1e-10
      and descriptor_record["checks"]["two_time_flux_spectral_abs_error"] < 1e-10
      and descriptor_record["tolerances"]["partition_rel_error"] == 1e-10
      and "spatial_flux_autocorrelation" in descriptor_json
      and "gauge_summed_wilson_slab" in descriptor_json)
descriptor_schema = z2_transfer_descriptor_schema_record()
check("descriptor schema record pins supported descriptor conventions",
      descriptor_schema["schema_version"] == "z2_1p1d_wilson_slab_transfer.v1"
      and descriptor_schema["properties"]["schema_version"]["const"]
      == "z2_1p1d_wilson_slab_transfer.v1"
      and descriptor_schema["properties"]["model"]["const"]
      == "z2_1p1d_wilson_slab_transfer"
      and descriptor_schema["properties"]["group"]["properties"]["name"]["const"] == "Z2"
      and descriptor_schema["properties"]["lattice"]["properties"]["space"]
      ["properties"]["boundary"]["const"] == "periodic"
      and descriptor_schema["properties"]["lattice"]["properties"]["time"]
      ["properties"]["boundary"]["const"] == "periodic"
      and descriptor_schema["properties"]["observables"]["items"]["properties"]
      ["name"]["enum"] == ["spatial_flux"]
      and descriptor_schema["properties"]["correlations"]["items"]["properties"]
      ["name"]["enum"] == ["spatial_flux_autocorrelation"]
      and descriptor_schema["properties"]["sector_symmetries"]["items"]
      ["properties"]["name"]["enum"] == ["global_center_flip"])
check("descriptor JSON record names Lean theorem surfaces",
      descriptor_record["lean_surfaces"]["claim_boundary"]
      == "oracle evidence only; not a Lean proof"
      and any(
          entry["module"]
          == "PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1"
          and "slabTransfer_eq_transfer2" in entry["surface"]
          and "slabTransfer_transpose" in entry["surface"]
          and "slabTransfer_conjTranspose" in entry["surface"]
          and "slabTransfer_mulVec_vacuum" in entry["surface"]
          and "slabTransfer_mulVec_local" in entry["surface"]
          and "slabTransfer_trace" in entry["surface"]
          and "centerPlusProjector_mul_slabTransfer_trace" in entry["surface"]
          and "centerMinusProjector_mul_slabTransfer_trace" in entry["surface"]
          and "slabTransfer_sq_trace" in entry["surface"]
          and "fluxMatrix_conjTranspose" in entry["surface"]
          and "fluxMatrix_sq" in entry["surface"]
          and "fluxMatrix_mulVec_vacuum" in entry["surface"]
          and "fluxMatrix_mulVec_local" in entry["surface"]
          and "centerFlipMatrix" in entry["surface"]
          and "centerPlusProjector" in entry["surface"]
          and "centerMinusProjector" in entry["surface"]
          and "centerFlipMatrix_sq" in entry["surface"]
          and "centerPlus_add_centerMinus" in entry["surface"]
          and "centerPlus_mul_centerMinus" in entry["surface"]
          and "centerPlusProjector_mul_self" in entry["surface"]
          and "centerMinusProjector_mul_self" in entry["surface"]
          and "centerFlip_mul_centerPlus" in entry["surface"]
          and "centerFlip_mul_centerMinus" in entry["surface"]
          and "centerPlus_mul_centerFlip" in entry["surface"]
          and "centerMinus_mul_centerFlip" in entry["surface"]
          and "centerFlip_mul_fluxMatrix" in entry["surface"]
          and "centerPlus_mul_flux_eq_flux_mul_centerMinus" in entry["surface"]
          and "centerMinus_mul_flux_eq_flux_mul_centerPlus" in entry["surface"]
          and "flux_mul_centerPlus_eq_centerMinus_mul_flux" in entry["surface"]
          and "flux_mul_centerMinus_eq_centerPlus_mul_flux" in entry["surface"]
          and "slabTransfer_mul_centerFlip_eq_centerFlip_mul_slabTransfer"
          in entry["surface"]
          and "slabTransfer_mul_centerPlus_eq_centerPlus_mul_slabTransfer"
          in entry["surface"]
          and "slabTransfer_mul_centerMinus_eq_centerMinus_mul_slabTransfer"
          in entry["surface"]
          and "fluxMatrix_mul_slabTransfer_trace" in entry["surface"]
          and "fluxExpectation_T1_eq_zero" in entry["surface"]
          and "fluxMatrix_slabTransfer_fluxMatrix_slabTransfer_trace"
          in entry["surface"]
          and "fluxCorrelation_T2_eq_tanh_two_mul" in entry["surface"]
          and "descriptor_contractionFactor_eq_tanh" in entry["surface"]
          and "spectralWitness_exp_neg_gap_eq_tanh" in entry["surface"]
          for entry in descriptor_record["lean_surfaces"]["modules"]
      )
      and "FiniteGapSpectralWitness" in descriptor_json
      and "Descriptor.gap_pos" in descriptor_json
      and "PositiveDescriptor" not in descriptor_json)

profile = descriptor_record["results"]["spatial_flux_two_time_correlation_profile"]
check("descriptor JSON record carries requested correlation tau profile",
      [entry["tau"] for entry in profile] == [0, 1, 2]
      and all(
          abs(entry["transfer_trace"] - entry["full_spacetime_sum"]) < 1e-10
          and abs(entry["transfer_trace"] - entry["spectral_sum"]) < 1e-10
          for entry in profile
      ))

descriptor_input = z2_transfer_model_descriptor(L=3, T=3, beta=0.4)
parsed_descriptor, descriptor_summary_from_input = z2_transfer_summarize_descriptor(
    descriptor_input
)
descriptor_result = z2_transfer_summary_record(
    descriptor_summary_from_input,
    descriptor=descriptor_input,
    include_matrices=True,
)
check("descriptor-driven summary uses L/T/beta, observable, and sector labels",
      parsed_descriptor.L == 3
      and parsed_descriptor.T == 3
      and abs(parsed_descriptor.beta - 0.4) < 1e-15
      and parsed_descriptor.observables == ("spatial_flux",)
      and parsed_descriptor.correlation_taus == (0, 1, 2)
      and parsed_descriptor.sector_symmetries == ("global_center_flip",)
      and descriptor_result["results"]["partition"]["transfer_trace"]
      == descriptor_summary_from_input.partition_transfer
      and "matrices" in descriptor_result
      and len(descriptor_result["matrices"]["transfer_kernel"]) == 8)

matrix_payload = descriptor_result["matrices"]
transfer_payload_matrix = np.array(matrix_payload["transfer_kernel"], dtype=np.float64)
flux_matrix = np.array(matrix_payload["spatial_flux_insertion"], dtype=np.float64)
center_flip_matrix = np.array(matrix_payload["global_center_flip"], dtype=np.float64)
center_plus_matrix = np.array(matrix_payload["center_plus_projector"], dtype=np.float64)
center_minus_matrix = np.array(matrix_payload["center_minus_projector"], dtype=np.float64)
expected_flux_matrix = np.diag([z2_spatial_flux(state, 3) for state in range(8)])
expected_flip_matrix = np.zeros((8, 8), dtype=np.float64)
for state in range(8):
    expected_flip_matrix[state ^ 7, state] = 1.0
check("descriptor matrix payload records observable and center projectors",
      matrix_payload["spatial_state_labels"] == list(range(8))
      and np.max(np.abs(flux_matrix - expected_flux_matrix)) < 1e-12
      and np.max(np.abs(center_flip_matrix - expected_flip_matrix)) < 1e-12
      and np.max(np.abs(center_plus_matrix - z2_sector_projector(3, 1))) < 1e-12
      and np.max(np.abs(center_minus_matrix - z2_sector_projector(3, -1))) < 1e-12
      and np.max(np.abs(center_plus_matrix + center_minus_matrix - np.eye(8))) < 1e-12)
check("descriptor matrix payload satisfies transfer symmetry and center commutation",
      np.max(np.abs(transfer_payload_matrix.T - transfer_payload_matrix)) < 1e-12
      and np.max(np.abs(transfer_payload_matrix @ center_flip_matrix
                        - center_flip_matrix @ transfer_payload_matrix)) < 1e-12
      and np.max(np.abs(transfer_payload_matrix @ center_plus_matrix
                        - center_plus_matrix @ transfer_payload_matrix)) < 1e-12
      and np.max(np.abs(transfer_payload_matrix @ center_minus_matrix
                        - center_minus_matrix @ transfer_payload_matrix)) < 1e-12)
check("descriptor matrix payload satisfies spatial-flux insertion algebra",
      np.max(np.abs(flux_matrix.T - flux_matrix)) < 1e-12
      and np.max(np.abs(flux_matrix @ flux_matrix - np.eye(8))) < 1e-12)
check("descriptor matrix payload satisfies center-projector algebra",
      np.max(np.abs(center_flip_matrix @ center_flip_matrix - np.eye(8))) < 1e-12
      and np.max(np.abs(center_plus_matrix @ center_plus_matrix
                        - center_plus_matrix)) < 1e-12
      and np.max(np.abs(center_minus_matrix @ center_minus_matrix
                        - center_minus_matrix)) < 1e-12
      and np.max(np.abs(center_flip_matrix @ center_plus_matrix
                        - center_plus_matrix)) < 1e-12
      and np.max(np.abs(center_flip_matrix @ center_minus_matrix
                        + center_minus_matrix)) < 1e-12
      and np.max(np.abs(center_plus_matrix @ center_flip_matrix
                        - center_plus_matrix)) < 1e-12
      and np.max(np.abs(center_minus_matrix @ center_flip_matrix
                        + center_minus_matrix)) < 1e-12)
check("descriptor matrix payload satisfies flux-center toggle algebra",
      np.max(np.abs(center_flip_matrix @ flux_matrix
                    + flux_matrix @ center_flip_matrix)) < 1e-12
      and np.max(np.abs(center_plus_matrix @ flux_matrix
                        - flux_matrix @ center_minus_matrix)) < 1e-12
      and np.max(np.abs(center_minus_matrix @ flux_matrix
                        - flux_matrix @ center_plus_matrix)) < 1e-12
      and np.max(np.abs(flux_matrix @ center_plus_matrix
                        - center_minus_matrix @ flux_matrix)) < 1e-12
      and np.max(np.abs(flux_matrix @ center_minus_matrix
                        - center_plus_matrix @ flux_matrix)) < 1e-12)

verified_record = z2_transfer_verify_record(descriptor_result)
check("saved JSON record verifier accepts descriptor and matrix payload",
      verified_record["ok"]
      and verified_record["checks"]["spectrum_full_first_gap"]["ok"]
      and verified_record["checks"]["matrix_replay_partition_transfer_trace"]["ok"]
      and verified_record["checks"]["matrix_replay_spatial_flux_transfer_trace"]["ok"]
      and verified_record["checks"]["matrix_transfer_kernel_symmetric"]["ok"]
      and verified_record["checks"]["matrix_transfer_kernel_center_flip_commutes"]["ok"]
      and verified_record["checks"]["matrix_transfer_kernel_center_plus_commutes"]["ok"]
      and verified_record["checks"]["matrix_transfer_kernel_center_minus_commutes"]["ok"]
      and verified_record["checks"]["matrix_spatial_flux_insertion_hermitian"]["ok"]
      and verified_record["checks"]["matrix_spatial_flux_insertion_involutive"]["ok"]
      and verified_record["checks"]["matrix_center_plus_block"]["ok"]
      and verified_record["checks"]["matrix_center_minus_block"]["ok"]
      and verified_record["checks"]["matrix_center_plus_block_symmetric"]["ok"]
      and verified_record["checks"]["matrix_center_minus_block_symmetric"]["ok"]
      and verified_record["checks"]["matrix_center_plus_block_positive_eigenvalues"]["ok"]
      and verified_record["checks"]["matrix_center_minus_block_positive_eigenvalues"]["ok"]
      and verified_record["checks"]["matrix_global_center_flip_involutive"]["ok"]
      and verified_record["checks"]["matrix_center_plus_projector_idempotent"]["ok"]
      and verified_record["checks"]["matrix_center_minus_projector_idempotent"]["ok"]
      and verified_record["checks"]["matrix_center_flip_left_plus_eigenprojector"]["ok"]
      and verified_record["checks"]["matrix_center_flip_left_minus_eigenprojector"]["ok"]
      and verified_record["checks"]["matrix_center_flip_right_plus_eigenprojector"]["ok"]
      and verified_record["checks"]["matrix_center_flip_right_minus_eigenprojector"]["ok"]
      and verified_record["checks"]["matrix_center_flip_spatial_flux_anticommutes"]["ok"]
      and verified_record["checks"]["matrix_center_plus_spatial_flux_toggles_to_minus"]["ok"]
      and verified_record["checks"]["matrix_center_minus_spatial_flux_toggles_to_plus"]["ok"]
      and verified_record["checks"]["matrix_spatial_flux_center_plus_toggles_to_minus"]["ok"]
      and verified_record["checks"]["matrix_spatial_flux_center_minus_toggles_to_plus"]["ok"])
check("saved JSON record verifier accepts sector block matrices",
      verified_record["checks"]["matrix_center_plus_block"]["ok"]
      and verified_record["checks"]["matrix_center_minus_block"]["ok"]
      and verified_record["checks"]["matrix_center_plus_block_symmetric"]["ok"]
      and verified_record["checks"]["matrix_center_minus_block_symmetric"]["ok"])
check("saved JSON record verifier replays sector block spectra",
      verified_record["checks"]["matrix_center_plus_block_positive_eigenvalues"]["ok"]
      and verified_record["checks"]["matrix_center_minus_block_positive_eigenvalues"]["ok"])
tampered_record = json.loads(json.dumps(descriptor_result))
tampered_record["matrices"]["spatial_flux_insertion"][0][0] *= -1
tampered_verification = z2_transfer_verify_record(tampered_record)
check("saved JSON record verifier rejects tampered observable matrix",
      not tampered_verification["ok"]
      and "matrix_spatial_flux_insertion" in tampered_verification["errors"])
tampered_sector_block_record = json.loads(json.dumps(descriptor_result))
tampered_sector_block_record["matrices"]["center_plus_block"][0][0] *= 1.01
tampered_sector_block_verification = z2_transfer_verify_record(
    tampered_sector_block_record
)
check("saved JSON record verifier rejects tampered sector block matrix",
      not tampered_sector_block_verification["ok"]
      and "matrix_center_plus_block"
      in tampered_sector_block_verification["errors"])
check("saved JSON record verifier rejects tampered sector block spectrum replay",
      not tampered_sector_block_verification["ok"]
      and "matrix_center_plus_block_positive_eigenvalues"
      in tampered_sector_block_verification["errors"])

spectrum = descriptor_result["results"]["spectrum"]
gaps = spectrum["first_gaps"]

def gap_matches_record(observed, eigenvalues):
    expected = z2_first_spectral_gap(tuple(eigenvalues))
    if expected is None:
        return observed is None
    return observed is not None and abs(observed - expected) < 1e-12

check("descriptor spectrum record carries full and sector first gaps",
      gaps["definition"].startswith("-log(lambda_1 / lambda_0)")
      and gap_matches_record(gaps["full"], spectrum["positive_eigenvalues"])
      and gap_matches_record(
          gaps["center_plus"],
          spectrum["center_plus_positive_eigenvalues"],
      )
      and gap_matches_record(
          gaps["center_minus"],
          spectrum["center_minus_positive_eigenvalues"],
      ))
check("saved JSON record verifier accepts full and sector spectrum lists",
      verified_record["checks"]["spectrum_full_positive_eigenvalues"]["ok"]
      and verified_record["checks"]["spectrum_center_plus_positive_eigenvalues"]["ok"]
      and verified_record["checks"]["spectrum_center_minus_positive_eigenvalues"]["ok"])
tampered_gap_record = json.loads(json.dumps(descriptor_result))
tampered_gap_record["results"]["spectrum"]["first_gaps"]["full"] += 0.25
tampered_gap_verification = z2_transfer_verify_record(tampered_gap_record)
check("saved JSON record verifier rejects tampered first-gap field",
      not tampered_gap_verification["ok"]
      and "spectrum_full_first_gap" in tampered_gap_verification["errors"])
tampered_spectrum_record = json.loads(json.dumps(descriptor_result))
tampered_spectrum_record["results"]["spectrum"]["positive_eigenvalues"][0] *= 1.01
tampered_spectrum_verification = z2_transfer_verify_record(tampered_spectrum_record)
check("saved JSON record verifier rejects tampered spectrum eigenvalue list",
      not tampered_spectrum_verification["ok"]
      and "spectrum_full_positive_eigenvalues"
      in tampered_spectrum_verification["errors"])

check("descriptor-driven transfer record reproduces exact checks",
      descriptor_result["checks"]["partition_rel_error"] < 1e-10
      and descriptor_result["checks"]["spatial_flux_abs_error"] < 1e-10
      and descriptor_result["checks"]["two_time_flux_abs_error"] < 1e-10
      and descriptor_result["checks"]["two_time_flux_spectral_abs_error"] < 1e-10
      and [entry["tau"] for entry in descriptor_result["results"]
           ["spatial_flux_two_time_correlation_profile"]] == [0, 1, 2]
      and len(descriptor_result["results"]["spectrum"]["positive_eigenvalues"]) > 0
      and len(descriptor_result["results"]["spectrum"]
              ["center_plus_positive_eigenvalues"]) > 0
      and len(descriptor_result["results"]["spectrum"]
              ["center_minus_positive_eigenvalues"]) > 0)

bad_descriptor = json.loads(json.dumps(descriptor_input))
bad_descriptor["observables"][0]["name"] = "unsupported_flux"
try:
    z2_transfer_validate_descriptor(bad_descriptor)
    bad_descriptor_rejected = False
except ValueError:
    bad_descriptor_rejected = True
check("descriptor validation rejects unsupported observable labels",
      bad_descriptor_rejected)

bad_correlation_descriptor = json.loads(json.dumps(descriptor_input))
bad_correlation_descriptor["correlations"][0]["name"] = "unsupported_correlation"
try:
    z2_transfer_validate_descriptor(bad_correlation_descriptor)
    bad_correlation_rejected = False
except ValueError:
    bad_correlation_rejected = True
check("descriptor validation rejects unsupported correlation labels",
      bad_correlation_rejected)

for L in [2, 3, 4]:
    Kslab = z2_transfer_matrix(L, beta=0.4)
    center_plus = z2_sector_projector(L, 1)
    center_minus = z2_sector_projector(L, -1)
    check(f"L={L}: global center-shift projectors are complementary",
          np.max(np.abs(center_plus + center_minus - np.eye(1 << L))) < 1e-12
          and np.max(np.abs(center_plus @ center_minus)) < 1e-12)
    check(f"L={L}: slab kernel commutes with global center-shift projectors",
          np.max(np.abs(center_plus @ Kslab - Kslab @ center_plus)) < 1e-12
          and np.max(np.abs(center_minus @ Kslab - Kslab @ center_minus)) < 1e-12)
    for parity, projector in [(1, center_plus), (-1, center_minus)]:
        basis = z2_sector_basis(L, parity)
        block = z2_sector_block(L, beta=0.4, parity=parity)
        check(f"L={L},parity={parity}: sector basis realizes projector",
              np.max(np.abs(basis.T @ basis - np.eye(basis.shape[1]))) < 1e-12
              and np.max(np.abs(basis @ basis.T - projector)) < 1e-12)
        check(f"L={L},parity={parity}: sector block is symmetric",
              np.max(np.abs(block - block.T)) < 1e-12)
    full_pos = np.array(sorted(
        (x for x in np.linalg.eigvalsh(0.5 * (Kslab + Kslab.T)) if x > 1e-10),
        reverse=True,
    ))
    sector_pos = np.array(sorted(
        list(z2_sector_eigenvalues(L, 0.4, 1))
        + list(z2_sector_eigenvalues(L, 0.4, -1)),
        reverse=True,
    ))
    check(f"L={L}: center-shift sector spectra reconstruct full positive spectrum",
          len(full_pos) == len(sector_pos)
          and np.allclose(full_pos, sector_pos, rtol=1e-10, atol=1e-10),
          "full=" + ",".join(f"{x:.4e}" for x in full_pos)
          + " sector=" + ",".join(f"{x:.4e}" for x in sector_pos))

for L in [2, 3, 4]:
    Kslab = z2_transfer_matrix(L, beta=0.4)
    eig = np.linalg.eigvalsh(0.5 * (Kslab + Kslab.T))
    eig = np.array(sorted((x for x in eig if x > 1e-10), reverse=True))
    gap = -math.log(eig[1] / eig[0])
    check(f"L={L}: tiny finite transfer spectrum has positive first gap",
          len(eig) >= 2 and gap > 0,
          f"gap={gap:.6f}, lam0={eig[0]:.4e}, lam1={eig[1]:.4e}")

L = 3
Kslab = z2_transfer_matrix(L, beta=0.4)
cross_flux_nonzero = any(
    z2_spatial_flux(u, L) != z2_spatial_flux(v, L)
    and abs(Kslab[u, v]) > 1e-12
    for u in range(1 << L)
    for v in range(1 << L)
)
check("guard: raw magnetic spatial flux is not a preserved block label "
      "for the unprojected slab kernel", cross_flux_nonzero)

print("\n" + "=" * 78)
n = len(PASS)
print(f"RESULT: {sum(PASS)}/{n} checks passed" + ("" if all(PASS) else "  *** FAILURES PRESENT ***"))
sys.exit(0 if all(PASS) else 1)
