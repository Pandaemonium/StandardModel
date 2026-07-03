"""MP1' concentration pilot (v0): the two-curve protocol for the SCG R7 kill test.

Context (Sources/Null_Edge_Measure_Problem.md, gate MP1'): the SCG measure
candidate factorizes into a classical skeleton times skeleton-conditional
Gaussian decoration vacua, so its emergent vacuum is a classical MIXTURE of
Gaussian states.  Null-Markovianity (R7) then turns on whether the mixture's
conditional mutual information I(A:C|B) concentrates: the excess

    excess(sigma) := CMI(rho_mix) - E_s[ CMI(rho_s) ]

must vanish (quadratically in the component spread) as the skeleton ensemble
concentrates.  This v0 script calibrates the PROTOCOL on a disordered
free-fermion chain:

  * skeleton stand-in s = site-disordered staggered mass m_x = m (1 + sigma xi_x),
    xi_x ~ U(-1, 1) i.i.d. per sample (the real test replaces this with
    sprinkled 2D orders + the Sorkin-Johnston state; flagged v1);
  * per-skeleton vacuum = filled Fermi sea, correlation matrix C_s;
  * curve 1 (per-skeleton): E_s[CMI_s] via Peschel entropies from C_s;
  * curve 2 (mixture): CMI of rho_mix = E_s[rho_s], computed EXACTLY by
    reconstructing each region's Gaussian state from its correlation
    submatrix in a REGION-LOCAL Jordan-Wigner representation (each region's
    CAR algebra mapped separately, so no cross-region string subtleties
    enter the middle-block entropy), then averaging and diagonalizing.

Calibration facts verified by construction:
  (a) reconstruction consistency: Peschel entropy == exact entropy of the
      reconstructed state, and Tr(rho c_i^dag c_j) == C_R, per sample;
  (b) sigma = 0  =>  excess == 0 identically (all components equal);
  (c) small sigma  =>  excess ~ sigma^2 (smooth nonnegative, zero at 0).

v0 scope notes (pre-registered): regions are adjacent spatial intervals -
the protocol calibration.  v1 must (i) use null-cut geometry (the modular
mapping of the QNEC pilot), (ii) replace the disorder stand-in by sprinkled
2D orders with the Sorkin-Johnston per-skeleton state, and (iii) state the
discrete CMI stencil-aware (Round 5 lesson).  Exploratory oracle: NOT a
trusted proof, NOT a CI fixture.
"""

import numpy as np

rng = np.random.default_rng(12345)
LN2 = np.log(2.0)

# ---------------- chain and regions ----------------
N = 40            # chain length (open boundary)
M0 = 0.4          # staggered mass scale
A_SITES = [15, 16, 17]
B_SITES = [18, 19]
C_SITES = [20, 21, 22]
REGIONS = {
    "B": B_SITES,
    "AB": A_SITES + B_SITES,
    "BC": B_SITES + C_SITES,
    "ABC": A_SITES + B_SITES + C_SITES,
}
SIGMAS = [0.0, 0.05, 0.1, 0.2, 0.4]
NSAMP = 96
# Common random numbers: one disorder panel reused (scaled) across all sigma,
# so the excess-vs-sigma curve is a PAIRED estimate (variance reduction).
XI_PANEL = None  # drawn once in main loop setup

def correlation_matrix(masses):
    """Ground-state C[i,j] = <c_i^dag c_j> of the staggered-mass hopping chain."""
    h = np.zeros((N, N))
    for i in range(N - 1):
        h[i, i + 1] = h[i + 1, i] = -0.5
    for i in range(N):
        h[i, i] = ((-1) ** i) * masses[i]
    w, v = np.linalg.eigh(h)
    occ = v[:, w < 0.0]
    return occ @ occ.T

def peschel_entropy(csub):
    nu = np.linalg.eigvalsh(csub)
    nu = np.clip(nu, 1e-12, 1 - 1e-12)
    return float(-(nu * np.log(nu) + (1 - nu) * np.log(1 - nu)).sum())

def cmi_peschel(C):
    s = {k: peschel_entropy(C[np.ix_(r, r)]) for k, r in REGIONS.items()}
    return (s["AB"] + s["BC"] - s["B"] - s["ABC"]) / LN2   # bits

# ---------------- region-local Jordan-Wigner machinery ----------------
def jw_ops(n):
    """Annihilation operators c_i (2^n x 2^n, real) in a local JW rep."""
    c = np.array([[0.0, 1.0], [0.0, 0.0]])   # |1> -> |0>
    z = np.diag([1.0, -1.0])
    eye = np.eye(2)
    ops = []
    for i in range(n):
        m = np.array([[1.0]])
        for j in range(n):
            m = np.kron(m, z if j < i else (c if j == i else eye))
        ops.append(m)
    return ops

# precompute M_ij = c_i^dag c_j per region size (regions are small)
JW_CACHE = {}
for name, sites in REGIONS.items():
    n = len(sites)
    if n not in JW_CACHE:
        cs = jw_ops(n)
        JW_CACHE[n] = np.array([[cs[i].T @ cs[j] for j in range(n)] for i in range(n)])

def gaussian_density_matrix(csub):
    """Exact 2^n density matrix of the Gaussian state with <c^dag c> = csub."""
    n = csub.shape[0]
    nu, V = np.linalg.eigh(csub)
    nu = np.clip(nu, 1e-10, 1 - 1e-10)
    h_ent = V @ np.diag(np.log((1 - nu) / nu)) @ V.T
    K = np.einsum("ij,ijab->ab", h_ent, JW_CACHE[n])
    w, U = np.linalg.eigh(K)
    rho = U @ np.diag(np.exp(-w)) @ U.T
    return rho / np.trace(rho)

def vn_entropy(rho):
    w = np.linalg.eigvalsh(rho)
    w = w[w > 1e-14]
    return float(-(w * np.log(w)).sum())

# ---------------- self-checks on one clean sample ----------------
C0 = correlation_matrix(np.full(N, M0))
r = REGIONS["ABC"]
rho0 = gaussian_density_matrix(C0[np.ix_(r, r)])
n = len(r)
Crec = np.einsum("ab,ijba->ij", rho0, JW_CACHE[n])   # Tr(rho c_i^dag c_j)
err_corr = float(np.abs(Crec - C0[np.ix_(r, r)]).max())
err_ent = abs(vn_entropy(rho0) - peschel_entropy(C0[np.ix_(r, r)]))
print(f"self-check: |Tr(rho c'c) - C| = {err_corr:.2e}   |S_exact - S_Peschel| = {err_ent:.2e}")
assert err_corr < 1e-7 and err_ent < 1e-7, "reconstruction self-check failed"

# ---------------- the two-curve protocol ----------------
XI_PANEL = rng.uniform(-1, 1, size=(NSAMP, N))
print(f"\nchain N={N}, m={M0}, regions |A|,|B|,|C| = "
      f"{len(A_SITES)},{len(B_SITES)},{len(C_SITES)}, samples = {NSAMP} "
      f"(common random numbers across sigma)")
print(f"{'sigma':>6} | {'E_s[CMI_s] (bits)':>18} | {'CMI(mix) (bits)':>16} | "
      f"{'excess (bits)':>14}")
prev_excess = None
for sigma in SIGMAS:
    per_sample = []
    mix = {k: None for k in REGIONS}
    for k_samp in range(NSAMP):
        masses = M0 * (1 + sigma * XI_PANEL[k_samp])
        C = correlation_matrix(masses)
        per_sample.append(cmi_peschel(C))
        for k, rr in REGIONS.items():
            rho = gaussian_density_matrix(C[np.ix_(rr, rr)])
            mix[k] = rho if mix[k] is None else mix[k] + rho
    s_mix = {k: vn_entropy(m / NSAMP) for k, m in mix.items()}
    cmi_mix = (s_mix["AB"] + s_mix["BC"] - s_mix["B"] - s_mix["ABC"]) / LN2
    e_cmi = float(np.mean(per_sample))
    excess = cmi_mix - e_cmi
    note = ""
    if prev_excess is not None and excess > 1e-12:
        note = f"   ratio_prev/this = {prev_excess / excess:.2f}"
    print(f"{sigma:6.2f} | {e_cmi:18.6f} | {cmi_mix:16.6f} | {excess:14.6f}{note}")
    if sigma > 0:
        prev_excess = excess

print("\nreading: excess must be ~0 at sigma=0 (exact), grow ~sigma^2 for small")
print("sigma (halving sigma => ratio ~4), and the per-skeleton curve is the")
print("discretization baseline.  v1 = null cuts + sprinkled 2D orders + SJ state.")
