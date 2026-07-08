"""Zero-mode locus scan for the decorated-cycle transfer (post-P1 follow-up).

Context: probe P1 (`p1_tsolder_koide_probe.py`, verdict in
`AgentTasks/twoday-carrier-run-2026-07-07/TSOLDER_KAPPA_ANALYSIS.md` sec 4a)
found that the tetrahedral-decorated Z_3 cycle transfer has an EXACT zero
quasi-energy mode, an exact pi mode, and mod-pi double degeneracy, at
continue-cycle holonomy h = +/-90 deg with flip-phase winding +/-120 deg.
None of the control decorations showed this. This scan maps WHERE in
decoration space the zero mode lives, to pin the hypotheses of a finite
theorem ("holonomy-forced masslessness") before formalization.

Two scans:

- SCAN A (spinor cones, physically realizable slice): V unit directions at
  azimuths 2 pi j / V on a cone of half-angle chi about the z-axis; sweep
  chi. The registered tetrahedral case is V = 3, cos chi = 1/3. Report the
  chi values where the minimal |eigenphase| crosses zero, together with the
  holonomy there.

- SCAN B (abstract gauge-invariant data): uniform |t|, flip phases with
  winding w (f_v proportional to e^{2 pi i w v / V}), continue holonomy h
  spread uniformly (arg t = h/V). For each (V, w, |t|), sweep h and locate
  zero-mode crossings h*(|t|). THE question: is h* independent of |t|
  (topological - the Berry phase alone forces the massless mode) or not
  (fine-tuned)? The overall flip phase is a proven unitary-equivalence and
  is fixed to 0.

Numeric oracle only; NOT a Lean result. Findings feed the HOLONOMY-ZERO-MODE
thread's theorem statement.

Usage: python Scripts/oracle/p1_zero_mode_locus_scan.py
"""

import numpy as np


def transfer_from_data(v, t_abs, h, f_phases):
    """Transfer on 2v directed legs from gauge-invariant data.

    Continue amplitude t = t_abs * e^{i h / v} uniform; flip amplitudes
    |f| = sqrt(1 - t_abs^2) with per-corner phases f_phases[leg].
    """
    f_abs = np.sqrt(max(0.0, 1.0 - t_abs ** 2))
    t = t_abs * np.exp(1j * h / v)
    w = np.zeros((2 * v, 2 * v), dtype=complex)

    def idx(leg, s):
        return 2 * (leg % v) + s

    for leg in range(v):
        f = f_abs * np.exp(1j * f_phases[leg])
        w[idx(leg + 1, 0), idx(leg, 0)] = t
        w[idx(leg + 1, 0), idx(leg + 1, 1)] = -np.conj(f)
        w[idx(leg, 1), idx(leg, 0)] = f
        w[idx(leg, 1), idx(leg + 1, 1)] = np.conj(t)
    return w


def min_abs_phase(w):
    """Distance of the spectrum from eigenvalue 1 (zero quasi-energy)."""
    return float(np.min(np.abs(np.angle(np.linalg.eigvals(w)))))


def min_pi_phase(w):
    """Distance of the spectrum from eigenvalue -1 (pi quasi-energy)."""
    ph = np.angle(np.linalg.eigvals(w))
    return float(np.min(np.abs(np.abs(ph) - np.pi)))


# ---------------------------------------------------------------- SCAN A

def spinor_of_direction(n):
    n = np.asarray(n, dtype=float)
    n = n / np.linalg.norm(n)
    theta = np.arccos(np.clip(n[2], -1.0, 1.0))
    phi = np.arctan2(n[1], n[0])
    return np.array([np.cos(theta / 2.0),
                     np.exp(1j * phi) * np.sin(theta / 2.0)])


def corner_amplitudes(psi_in, psi_out):
    t = np.vdot(psi_out, psi_in)
    f = psi_in[0] * psi_out[1] - psi_in[1] * psi_out[0]
    return t, f


def cone_case(v, chi):
    """Gauge-fixed transfer for V directions on a cone of half-angle chi."""
    dirs = [np.array([np.sin(chi) * np.cos(2 * np.pi * j / v),
                      np.sin(chi) * np.sin(2 * np.pi * j / v),
                      np.cos(chi)]) for j in range(v)]
    psis = [spinor_of_direction(n) for n in dirs]
    ts, fs = [], []
    for leg in range(v):
        t, f = corner_amplitudes(psis[leg], psis[(leg + 1) % v])
        ts.append(t)
        fs.append(f)
    h = np.angle(np.prod(ts))
    # gauge-fix: uniformize arg t to h/v (as in the P1 probe)
    beta = np.zeros(v)
    for leg in range(v - 1):
        beta[leg + 1] = beta[leg] + np.angle(ts[leg]) - h / v
    f_phases = [np.angle(fs[leg]) + beta[leg] + beta[(leg + 1) % v]
                for leg in range(v)]
    t_abs = abs(ts[0])
    return transfer_from_data(v, t_abs, h, f_phases), h, t_abs


def scan_a():
    print("=== SCAN A: symmetric V-gon on a cone, sweep half-angle chi ===")
    for v in (3, 4, 5, 6):
        chis = np.linspace(0.02, np.pi - 0.02, 1201)
        g = np.array([min_abs_phase(cone_case(v, c)[0]) for c in chis])
        # find deep local minima and refine by ternary search
        hits = []
        for i in range(1, len(chis) - 1):
            if g[i] < g[i - 1] and g[i] < g[i + 1] and g[i] < 5e-2:
                lo, hi = chis[i - 1], chis[i + 1]
                for _ in range(60):
                    m1, m2 = lo + (hi - lo) / 3, hi - (hi - lo) / 3
                    if min_abs_phase(cone_case(v, m1)[0]) < \
                       min_abs_phase(cone_case(v, m2)[0]):
                        hi = m2
                    else:
                        lo = m1
                chi0 = 0.5 * (lo + hi)
                w0, h0, t0 = cone_case(v, chi0)
                hits.append((chi0, min_abs_phase(w0), h0, t0))
        if not hits:
            print(f"  V={v}: no zero-mode crossing on the cone family")
        for (chi0, res, h0, t0) in hits:
            print(f"  V={v}: zero mode at chi = {np.degrees(chi0):9.4f} deg "
                  f"(cos chi = {np.cos(chi0):+.6f})  residual {res:.2e}  "
                  f"holonomy = {np.degrees(h0):+9.4f} deg  "
                  f"|t|^2 = {t0**2:.6f}")


# ---------------------------------------------------------------- SCAN B

def scan_b():
    print("=== SCAN B: abstract (|t|, h) with flip winding w ===")
    for v in (3, 4):
        for wind in range(v):
            rows = []
            for t_abs in (0.2, 0.4, 1 / np.sqrt(3.0), 0.7, 0.9):
                f_phases = [2 * np.pi * wind * leg / v for leg in range(v)]
                hs = np.linspace(0.0, 2 * np.pi, 2401, endpoint=False)
                g = np.array([min_abs_phase(
                    transfer_from_data(v, t_abs, h, f_phases)) for h in hs])
                i = int(np.argmin(g))
                lo, hi = hs[i] - 2 * np.pi / 2400, hs[i] + 2 * np.pi / 2400
                for _ in range(60):
                    m1, m2 = lo + (hi - lo) / 3, hi - (hi - lo) / 3
                    if min_abs_phase(transfer_from_data(
                            v, t_abs, m1, f_phases)) < \
                       min_abs_phase(transfer_from_data(
                            v, t_abs, m2, f_phases)):
                        hi = m2
                    else:
                        lo = m1
                h0 = 0.5 * (lo + hi)
                res = min_abs_phase(transfer_from_data(v, t_abs, h0, f_phases))
                rows.append((t_abs, h0, res))
            achieved = [r for r in rows if r[2] < 1e-9]
            print(f"  V={v}, winding w={wind}:")
            for (t_abs, h0, res) in rows:
                mark = "ZERO" if res < 1e-9 else "none"
                print(f"    |t| = {t_abs:.4f}: best h = "
                      f"{np.degrees(h0):+9.4f} deg, min|E| = {res:.2e}  "
                      f"[{mark}]")
            if len(achieved) >= 2:
                hs0 = [np.degrees(r[1]) for r in achieved]
                spread = max(hs0) - min(hs0)
                print(f"    -> zero-mode locus: h* spread over |t| = "
                      f"{spread:.2e} deg "
                      f"({'TOPOLOGICAL (|t|-independent)' if spread < 1e-6 else '|t|-DEPENDENT'})")
            elif len(achieved) == 1:
                print("    -> single achieving |t| only; locus shape "
                      "undetermined on this grid")


if __name__ == "__main__":
    scan_a()
    scan_b()
