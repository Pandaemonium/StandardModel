"""P1 probe: the Z_3 tetrahedral carrier-to-leg reduction (T-SOLDER kappa).

Pre-registered in
`AgentTasks/twoday-carrier-run-2026-07-07/TSOLDER_KAPPA_ANALYSIS.md` sec 4
(P1, "the decider; numeric-first per methodology"), BEFORE this script was
written or run. This is a NUMERIC ORACLE, not a Lean result: it informs gate
M-KOIDE per its pre-registered clauses; it proves nothing.

Construction (conventions pinned where a kernel/registered result pins them):

- Three unit 2-spinors psi_1..psi_3 from three of the four tetrahedral
  regulator directions (pairwise cos theta = -1/3). Spinor of direction
  n = (sin t cos p, sin t sin p, cos t) is (cos(t/2), e^{ip} sin(t/2)).
- Corner amplitudes computed DIRECTLY from the spinors (no hand-set phases):
  continue t_v = <psi_{v+1}, psi_v> (overlap; |t| = cos(theta/2)),
  flip f_v = wedge(psi_v, psi_{v+1}) (|f| = sin(theta/2)); the magnitude
  dictionary is the 1+1 kernel bridge (onshell_wedge_normSq_eq_coin_sq).
- One-step synchronous corner-scattering transfer W on the 6 directed legs
  (leg l carries soldering psi_l; corner c_l joins legs l, l+1):
    in (l,+), (l+1,-)  ->  out (l+1,+), (l,-)
    with SU(2) corner block [[t, -conj(f)], [f, conj(t)]].
  The shift is absorbed into the corner relabeling (checkerboard one-step
  convention; ordering freedom is pinned palindromic per
  `GWRetardedTransfer.lean` - here all corners act synchronously, which is
  the palindromic-symmetric choice).
- Readouts:
  R0 (transcription reference, not a test): kappa_B2 = |f|^2 / (2 |t|^2)
     - this is what bookkeeping B2 ASSERTS; at tetrahedral it is 1 exactly.
  R2 (the measurement): eigenphases of W come in +/- pairs E_k labelled by
     Fourier momentum k in {0, 2pi/3, -2pi/3} (label read from
     eigenvectors). Solve the circulant leg ansatz mu_k = d + 2 Re(c e^{ik})
     exactly (inverse DFT of the positive triple), then
     kappa_measured = d^2 / (2 |c|^2), under each of the two candidate
     mass dictionaries: sqrt(m) = E and m = E.
  Also reported: Q = sum(m)/ (sum sqrt m)^2 per dictionary, and the angle
  between the sqrt-m vector and (1,1,1) (Koide <=> 45 degrees).
- Controls (pre-registered dictionary table rows): trine (cos = -1/2),
  orthogonal (cos = 0), near-collinear; plus gauge-invariance and
  triple-choice checks.

Kill conditions (verbatim from the pre-registration):
 (a) reduction does not have the d I + H shape at all -> Q07 ansatz not
     carrier-native; gate M-KOIDE VOID per its K3 clause. (Operationally:
     the +/- pairing or momentum labelling fails, or the positive triple
     cannot be assigned momenta.)
 (b) kappa lands off the table -> tetrahedral route dead; report measured
     kappa; it then PREDICTS Q = (1 + 1/kappa)/3 with no further freedom.

Usage: python Scripts/oracle/p1_tsolder_koide_probe.py
"""

import numpy as np

RNG = np.random.default_rng(20260707)


def spinor_of_direction(n):
    """Unit 2-spinor for celestial direction n (unit 3-vector)."""
    n = np.asarray(n, dtype=float)
    n = n / np.linalg.norm(n)
    theta = np.arccos(np.clip(n[2], -1.0, 1.0))
    phi = np.arctan2(n[1], n[0])
    return np.array([np.cos(theta / 2.0),
                     np.exp(1j * phi) * np.sin(theta / 2.0)])


def corner_amplitudes(psi_in, psi_out):
    """(continue, flip) amplitudes at a corner: overlap and wedge."""
    t = np.vdot(psi_out, psi_in)                      # <psi_out | psi_in>
    f = psi_in[0] * psi_out[1] - psi_in[1] * psi_out[0]  # wedge
    return t, f


def gauge_fixed_amplitudes(psis):
    """Corner amplitudes in the parallel-transport gauge.

    Raw spinor phases are unphysical: under psi_v -> e^{i b_v} psi_v the
    overlaps pick up phase differences and the wedges phase SUMS, and the
    naive transfer spectrum leaks b_v (found by this probe's own gauge
    check, run 1). The gauge-invariant data of the decorated cycle are
    |t_v|, |f_v|, and the cycle holonomy h = arg(t_1 t_2 t_3) (the Berry
    phase, = half the solid angle of the spherical triangle). We fix the
    gauge by distributing the holonomy uniformly over the continue
    amplitudes (arg t_v = h/3 for all v, the Z_3-symmetric choice) and
    transforming the wedges consistently; the residual global rephasing
    only rotates all flip phases together, which is unitarily equivalent
    (rephase the '-' orientation sector), so the spectrum below depends
    only on gauge-invariant data.
    """
    v = len(psis)
    ts, fs = [], []
    for leg in range(v):
        t, f = corner_amplitudes(psis[leg], psis[(leg + 1) % v])
        ts.append(t)
        fs.append(f)
    h = np.angle(np.prod(ts))
    beta = np.zeros(v)
    for leg in range(v - 1):
        # want arg(t_leg) + beta_leg - beta_{leg+1} = h/v
        beta[leg + 1] = beta[leg] + np.angle(ts[leg]) - h / v
    ts_fix = [ts[leg] * np.exp(1j * (beta[leg] - beta[(leg + 1) % v]))
              for leg in range(v)]
    fs_fix = [fs[leg] * np.exp(1j * (beta[leg] + beta[(leg + 1) % v]))
              for leg in range(v)]
    return ts_fix, fs_fix, h


def transfer_matrix(psis):
    """One-step synchronous corner-scattering transfer on directed legs."""
    v = len(psis)
    w = np.zeros((2 * v, 2 * v), dtype=complex)
    ts, fs, _ = gauge_fixed_amplitudes(psis)

    def idx(leg, s):
        return 2 * (leg % v) + s  # s = 0: '+', s = 1: '-'

    for leg in range(v):
        t, f = ts[leg], fs[leg]
        # corner between leg and leg+1:
        # out (leg+1,+) <- t * (leg,+)  - conj(f) * (leg+1,-)
        # out (leg,-)   <- f * (leg,+)  + conj(t) * (leg+1,-)
        w[idx(leg + 1, 0), idx(leg, 0)] = t
        w[idx(leg + 1, 0), idx(leg + 1, 1)] = -np.conj(f)
        w[idx(leg, 1), idx(leg, 0)] = f
        w[idx(leg, 1), idx(leg + 1, 1)] = np.conj(t)
    return w


def momentum_label(vec, v=3):
    """Assign a Fourier momentum index j (k = 2 pi j / v) to an eigenvector."""
    weights = []
    for j in range(v):
        k = 2.0 * np.pi * j / v
        acc = 0.0
        for s in (0, 1):
            mode = np.array([np.exp(1j * k * leg) for leg in range(v)])
            mode = mode / np.sqrt(v)
            comp = np.array([vec[2 * leg + s] for leg in range(v)])
            acc += abs(np.vdot(mode, comp)) ** 2
        weights.append(acc)
    return int(np.argmax(weights)), max(weights) / (sum(weights) + 1e-300)


def positive_triple(w, v=3):
    """Eigenphases of W in (+,-) pairs; return [(j, E_j)] for E_j > 0."""
    vals, vecs = np.linalg.eig(w)
    phases = np.angle(vals)
    order = np.argsort(phases)
    phases = phases[order]
    vecs = vecs[:, order]
    # pairing check: sorted phases should be symmetric about 0
    pair_defect = np.max(np.abs(phases + phases[::-1]))
    triple = []
    for i, e in enumerate(phases):
        if e > 1e-9:
            j, purity = momentum_label(vecs[:, i], v)
            triple.append((j, e, purity))
    return triple, pair_defect


def circulant_solve(triple, v=3):
    """Exact inverse-DFT solve of mu_j = d + 2 Re(c e^{i 2 pi j / v})."""
    d = float(np.mean([e for (_, e, _) in triple]))
    c = sum(e * np.exp(-1j * 2.0 * np.pi * j / v)
            for (j, e, _) in triple) / v
    return d, c


def koide_q(sqrt_m):
    sqrt_m = np.asarray(sqrt_m, dtype=float)
    return float(np.sum(sqrt_m ** 2) / (np.sum(sqrt_m) ** 2))


def angle_to_uniform_deg(sqrt_m):
    sqrt_m = np.asarray(sqrt_m, dtype=float)
    u = np.ones_like(sqrt_m) / np.sqrt(len(sqrt_m))
    cosang = float(np.dot(sqrt_m, u) / np.linalg.norm(sqrt_m))
    return float(np.degrees(np.arccos(np.clip(cosang, -1.0, 1.0))))


def hermitian_shape_readout(w, v=3):
    """R1: the natural Hermitian reduction (W + W^dag)/2 and its shape.

    Reports the diagonal (turn-slot) and hop (continue-slot) content of the
    orientation-even projection - the direct test of whether the dynamical
    reduction has Q07's `M = d I + H` shape with d = turn amplitude.
    """
    m = (w + w.conj().T) / 2.0
    # orientation-even projection: |leg, even> = (|leg,+> + |leg,->)/sqrt2
    p = np.zeros((v, 2 * v))
    for leg in range(v):
        p[leg, 2 * leg] = 1.0 / np.sqrt(2.0)
        p[leg, 2 * leg + 1] = 1.0 / np.sqrt(2.0)
    m_even = p @ m @ p.T
    diag = np.diag(m_even).real
    hops = np.array([m_even[leg, (leg + 1) % v] for leg in range(v)])
    return m, m_even, diag, hops


def _sublattice_defect(w):
    """Max mismatch between {phases} and {phases + pi} as multisets."""
    ph = np.sort(np.angle(np.linalg.eigvals(w)))
    shifted = np.sort(np.angle(np.exp(1j * (ph + np.pi))))
    return float(np.max(np.abs(ph - shifted)))


def _mass_classes(w):
    """Eigenphases mod pi, |representative| in [0, pi/2], deduplicated."""
    ph = np.angle(np.linalg.eigvals(w))
    reps = np.abs(np.angle(np.exp(2j * ph)) / 2.0)  # mod-pi representative
    reps = np.sort(reps)
    out = [reps[0]]
    for r in reps[1:]:
        if r - out[-1] > 1e-7:
            out.append(r)
    return np.array(out)


def run_case(name, dirs):
    psis = [spinor_of_direction(n) for n in dirs]
    # R0: transcription reference
    t0, f0 = corner_amplitudes(psis[0], psis[1])
    kappa_b2 = abs(f0) ** 2 / (2.0 * abs(t0) ** 2)
    w = transfer_matrix(psis)
    ts, fs, holonomy = gauge_fixed_amplitudes(psis)
    unit_defect = np.max(np.abs(w.conj().T @ w - np.eye(w.shape[0])))
    triple, pair_defect = positive_triple(w)
    print(f"=== {name} ===")
    print(f"  |t|^2 = {abs(t0)**2:.6f}  |f|^2 = {abs(f0)**2:.6f}  "
          f"cycle holonomy h = {np.degrees(holonomy):.2f} deg  "
          f"(unitarity defect {unit_defect:.2e})")
    print(f"  R0 transcription kappa_B2 = |f|^2/(2|t|^2) = {kappa_b2:.6f}")
    _, _, diag, hops = hermitian_shape_readout(w)
    print(f"  R1 Herm part, even sector: diag (turn slot) = "
          f"{np.array2string(diag, precision=4)}  "
          f"[sum = {np.sum(diag):.2e}; uniform-d needs equal entries]")
    print(f"     |hops| (continue slot) = "
          f"{np.array2string(np.abs(hops), precision=4)}   "
          f"[d I + H shape test: d_eff/|c_eff| = "
          f"{np.mean(np.abs(diag)) / (np.mean(np.abs(hops)) + 1e-300):.4f}]")
    print(f"  gauge-fixed flip phases (diffs are invariants): "
          f"{np.array2string(np.degrees([np.angle(x) for x in fs]), precision=2)} deg")
    all_phases = np.sort(np.angle(np.linalg.eigvals(w)))
    print(f"  raw eigenphases (rad): "
          f"{np.array2string(all_phases, precision=4)}")
    print(f"  eigenphase +/- pairing defect = {pair_defect:.2e}")
    # sublattice-aware extraction: the checkerboard transfer has an exact
    # E -> E + pi spectral symmetry (even/odd sublattice), so the physical
    # mass classes are eigenphases mod pi, representatives in (-pi/2, pi/2].
    shift_defect = _sublattice_defect(w)
    classes = _mass_classes(w)
    print(f"  E -> E + pi sublattice symmetry defect = {shift_defect:.2e}")
    print(f"  mass classes |E| mod pi = "
          f"{np.array2string(classes, precision=4)}")
    if len(classes) == 3:
        d_cl = float(np.mean(classes))
        # evenly-spaced exact circulant solve on class representatives
        resid = classes - d_cl
        c_abs = float(np.sqrt(np.sum(resid ** 2) / 6.0))
        kappa_cl = d_cl ** 2 / (2.0 * c_abs ** 2) if c_abs > 1e-12 else np.inf
        q_cl = koide_q(classes)
        ang_cl = angle_to_uniform_deg(classes)
        print(f"  R2' [classes, sqrt(m)=E]: d = {d_cl:.6f}, |c| = "
              f"{c_abs:.6f}, kappa_measured = {kappa_cl:.6f}, "
              f"Q = {q_cl:.6f}, angle-to-uniform = {ang_cl:.2f} deg")
    if len(triple) != 3:
        print(f"  KILL (a) CANDIDATE: naive positive triple has "
              f"{len(triple)} members, not 3 (zero mode / sublattice "
              f"symmetry); using class extraction above")
        return None
    for (j, e, purity) in triple:
        print(f"    sector j={j} (k=2pi*{j}/3): E = {e:.6f} rad "
              f"(momentum purity {purity:.3f})")
    for dict_name, g in (("sqrt(m)=E", lambda e: e),
                         ("m=E", np.sqrt)):
        dict_triple = [(j, float(g(e)), p) for (j, e, p) in triple]
        sqrt_m = np.array([sm for (_, sm, _) in dict_triple])
        d, c = circulant_solve(dict_triple)
        kappa = d ** 2 / (2.0 * abs(c) ** 2) if abs(c) > 1e-12 else np.inf
        q = koide_q(sqrt_m)
        ang = angle_to_uniform_deg(sqrt_m)
        pred_q = (1.0 + 1.0 / kappa) / 3.0 if np.isfinite(kappa) else 1.0 / 3.0
        print(f"  R2 [{dict_name}]: d = {d:.6f}, |c| = {abs(c):.6f}, "
              f"arg c = {np.degrees(np.angle(c)):.2f} deg")
        print(f"     kappa_measured = {kappa:.6f}   "
              f"Q_direct = {q:.6f}   Q_pred(kappa) = {pred_q:.6f}   "
              f"angle-to-uniform = {ang:.2f} deg (Koide <=> 45)")
    return triple


def main():
    tet = [np.array(v) / np.sqrt(3.0)
           for v in [(1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1)]]

    # --- the registered case: three tetrahedral directions
    run_case("TETRAHEDRAL (registered P1 case): dirs 1,2,3", tet[:3])

    # triple-choice check (any 3 of 4 equivalent by symmetry)
    run_case("TETRAHEDRAL triple-choice check: dirs 2,3,4", tet[1:])

    # gauge-invariance check: random rephasing of each spinor
    psis = [spinor_of_direction(n) for n in tet[:3]]
    w0 = transfer_matrix(psis)
    e0 = np.sort(np.angle(np.linalg.eigvals(w0)))
    psis_g = [np.exp(1j * RNG.uniform(0, 2 * np.pi)) * p for p in psis]
    wg = transfer_matrix(psis_g)
    eg = np.sort(np.angle(np.linalg.eigvals(wg)))
    print(f"=== gauge check: max eigenphase shift under rephasing = "
          f"{np.max(np.abs(e0 - eg)):.2e} ===")

    # --- controls from the pre-registered dictionary table
    # trine (2+1-natural): coplanar at 120 deg, pairwise cos = -1/2
    trine = [np.array([np.cos(a), np.sin(a), 0.0])
             for a in (0.0, 2 * np.pi / 3, 4 * np.pi / 3)]
    run_case("CONTROL trine (cos theta = -1/2)", trine)

    # orthogonal triple: pairwise cos = 0
    ortho = [np.array(v, dtype=float)
             for v in [(1, 0, 0), (0, 1, 0), (0, 0, 1)]]
    run_case("CONTROL orthogonal (cos theta = 0)", ortho)

    # near-collinear: small cone about z (theta ~ 0.2 rad pairwise-ish)
    eps = 0.1
    nc = [np.array([eps * np.cos(a), eps * np.sin(a), 1.0])
          for a in (0.0, 2 * np.pi / 3, 4 * np.pi / 3)]
    run_case("CONTROL near-collinear (small cone)", nc)


if __name__ == "__main__":
    main()
