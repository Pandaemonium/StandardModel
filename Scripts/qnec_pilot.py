"""
Gate P3 calibration pilot: discrete QNEC on a 1+1d free-fermion chain.

Setup
-----
Spinless free fermions, H = -1/2 sum (c_i^dag c_{i+1} + h.c.) + m sum (-1)^i n_i,
half filling. Massless case (m=0) is a c=1 CFT (one Dirac fermion).
Entanglement entropy of an interval of length L from the correlation matrix
(Peschel): S = sum_k h(nu_k), h(x) = -x ln x - (1-x) ln(1-x), nu_k = eigenvalues
of C restricted to the interval.

Null-deformation proxy (static vacuum, Lorentz-invariant continuum limit):
entropy of a boosted/null-deformed interval depends only on the invariant
length Lbar = sqrt(x+ x-). With S = S(Lbar) and equal-time point x+ = x- = L:

    d+ S      = S'(L)/2
    d+^2 S    = (1/4) [ S''(L) - S'(L)/L ]

QNEC (vacuum, <T_++> = 0):        K(L) := (1/4)[S'' - S'/L]              <= 0
2d CFT-improved QNEC (c=1):       Q(L) := (1/4)[S'' - S'/L + 6 S'^2]     -> 0 (saturation, massless)

Lattice derivatives use parity-2 stencils to cancel the (-1)^L Friedel
oscillation at half filling:
    S'(L)  ~ [S(L+2) - S(L-2)] / 4
    S''(L) ~ [S(L+2) - 2 S(L) + S(L-2)] / 4
"""
import numpy as np

def entropy_from_corr(Csub):
    nu = np.linalg.eigvalsh(Csub)
    nu = np.clip(nu, 1e-14, 1 - 1e-14)
    return float(np.sum(-nu*np.log(nu) - (1-nu)*np.log(1-nu)))

# ---------- massless: exact infinite-volume kernel, half filling ----------
def massless_S(Lmax):
    idx = np.arange(Lmax)
    d = idx[:, None] - idx[None, :]
    with np.errstate(divide='ignore', invalid='ignore'):
        C = np.sin(np.pi * d / 2) / (np.pi * d)
    np.fill_diagonal(C, 0.5)
    S = {}
    for L in range(2, Lmax + 1):
        S[L] = entropy_from_corr(C[:L, :L])
    return S

# ---------- massive: staggered mass, finite periodic chain ----------
def massive_S(m, N, Lmax):
    h = np.zeros((N, N))
    for i in range(N):
        h[i, (i+1) % N] = -0.5
        h[(i+1) % N, i] = -0.5
        h[i, i] = m * (-1)**i
    e, U = np.linalg.eigh(h)
    occ = U[:, e < 0.0]          # half filling: fill negative-energy modes
    C = occ @ occ.conj().T
    S = {}
    for L in range(2, Lmax + 1):
        S[L] = entropy_from_corr(C[:L, :L])
    return S

def null_combos(S, Ls):
    out = []
    for L in Ls:
        if (L-2) in S and (L+2) in S:
            Sp  = (S[L+2] - S[L-2]) / 4.0
            Spp = (S[L+2] - 2*S[L] + S[L-2]) / 4.0
            K = 0.25 * (Spp - Sp / L)
            Q = 0.25 * (Spp - Sp / L + 6.0 * Sp**2)
            out.append((L, S[L], Sp, Spp, K, Q))
    return out

Lmax = 120
S0 = massless_S(Lmax + 2)

# central-charge fit on the massless data (even L to kill oscillation)
Ls_fit = np.array([L for L in range(20, Lmax, 2)])
A = np.vstack([np.log(Ls_fit), np.ones_like(Ls_fit, dtype=float)]).T
coef, *_ = np.linalg.lstsq(A, np.array([S0[L] for L in Ls_fit]), rcond=None)
c_fit = 3.0 * coef[0]
print(f"massless: fitted central charge c = {c_fit:.4f}  (target 1.0)")

rows0 = null_combos(S0, range(4, Lmax, 2))
print("\nmassless (m=0): CFT vacuum -- expect K < 0 (strict QNEC), Q -> 0 (saturation)")
print(f"{'L':>4} {'S(L)':>9} {'K(L)':>12} {'Q(L)':>12} {'L^2*Q':>10}")
for (L, s, sp, spp, K, Q) in rows0:
    if L in (4, 8, 16, 32, 48, 64, 80, 96, 112):
        print(f"{L:>4} {s:>9.5f} {K:>12.3e} {Q:>12.3e} {L*L*Q:>10.4f}")

viol0 = [(L, K) for (L, s, sp, spp, K, Q) in rows0 if K > 0]
violQ0 = [(L, Q) for (L, s, sp, spp, K, Q) in rows0 if Q > 1e-6]
print(f"plain-QNEC violations (K>0): {len(viol0)} ; improved-bound violations (Q>1e-6): {len(violQ0)}")

for m in (0.05, 0.2):
    Sm = massive_S(m, N=800, Lmax=Lmax + 2)
    rows = null_combos(Sm, range(4, Lmax, 2))
    Ssat = Sm[Lmax]
    print(f"\nmassive m={m}: expect S saturating (xi ~ 1/m ~ {1/m:.0f}), K strictly < 0, Q < 0")
    print(f"{'L':>4} {'S(L)':>9} {'K(L)':>12} {'Q(L)':>12}")
    for (L, s, sp, spp, K, Q) in rows:
        if L in (4, 8, 16, 32, 48, 64, 96):
            print(f"{L:>4} {s:>9.5f} {K:>12.3e} {Q:>12.3e}")
    viol = [(L, K) for (L, s, sp, spp, K, Q) in rows if K > 0]
    print(f"S(120) = {Ssat:.5f} ; plain-QNEC violations (K>0): {len(viol)}")

# save arrays for the plot script
np.save('/home/claude/qnec_massless.npy', np.array(rows0))
for m in (0.05, 0.2):
    Sm = massive_S(m, N=800, Lmax=Lmax + 2)
    np.save(f'/home/claude/qnec_m{m}.npy', np.array(null_combos(Sm, range(4, Lmax, 2))))
print("\nsaved arrays.")
