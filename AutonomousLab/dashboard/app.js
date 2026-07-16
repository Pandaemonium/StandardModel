"use strict";

const state = {
  refreshSeconds: Number(localStorage.getItem("afpl-refresh-seconds")) || 30,
  timer: null,
  loading: false,
};

const $ = (id) => document.getElementById(id);

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function cssStatus(value) {
  return String(value ?? "neutral").toLowerCase().replaceAll("_", "-");
}

function titleCase(value) {
  return String(value ?? "")
    .replaceAll("_", " ")
    .replaceAll("-", " ")
    .replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function shortText(value, limit = 190) {
  const text = String(value ?? "").trim();
  return text.length > limit ? `${text.slice(0, limit - 3)}...` : text;
}

function relativeTime(seconds) {
  if (seconds === null || seconds === undefined || Number.isNaN(seconds)) return "unscheduled";
  const late = seconds < 0;
  let remaining = Math.abs(seconds);
  const days = Math.floor(remaining / 86400);
  remaining -= days * 86400;
  const hours = Math.floor(remaining / 3600);
  remaining -= hours * 3600;
  const minutes = Math.floor(remaining / 60);
  const parts = [];
  if (days) parts.push(`${days}d`);
  if (hours || days) parts.push(`${hours}h`);
  parts.push(`${minutes}m`);
  return late ? `${parts.join(" ")} late` : `in ${parts.join(" ")}`;
}

function formatTime(value) {
  if (!value) return "--";
  if (/^\d{4}-\d{2}-\d{2}$/.test(String(value))) {
    const [year, month, day] = String(value).split("-").map(Number);
    return new Date(year, month - 1, day).toLocaleDateString([], {
      month: "short",
      day: "numeric",
      year: "numeric",
    });
  }
  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString([], {
    month: "short",
    day: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function repoLink(path, label) {
  if (!path) return "";
  const url = `/repo/${String(path).split("/").map(encodeURIComponent).join("/")}`;
  return `<a href="${url}" target="_blank" rel="noopener">${escapeHtml(label || path)}</a>`;
}

function renderKpis(kpis) {
  const definitions = [
    ["Active projects", kpis.active_projects, ""],
    ["Active work", kpis.active_work, ""],
    ["In review", kpis.review_work, kpis.review_work ? "warn" : "good"],
    ["Blocked", kpis.blocked_work, kpis.blocked_work ? "danger" : "good"],
    ["Roles overdue", kpis.overdue_roles, kpis.overdue_roles ? "danger" : "good"],
    ["Aristotle active", kpis.active_jobs, ""],
    ["Mailbox actions", kpis.action_messages, kpis.action_messages ? "warn" : "good"],
    ["Machine claims", kpis.machine_claims, "good"],
  ];
  $("kpi-strip").innerHTML = definitions.map(([label, value, className]) => `
    <div class="kpi ${className}">
      <span>${escapeHtml(label)}</span>
      <strong>${escapeHtml(value)}</strong>
    </div>
  `).join("");
}

function renderProjects(projects) {
  $("project-count").textContent = `${projects.length} tracked programs`;
  $("project-list").classList.remove("loading-block");
  $("project-list").innerHTML = projects.length ? projects.map((project) => `
    <article class="project-row">
      <div>
        <span class="project-id">${escapeHtml(project.id)}</span>
        <p>P${escapeHtml(project.priority)}</p>
      </div>
      <div>
        <strong class="project-title">${escapeHtml(project.title)}</strong>
        <p>${escapeHtml(project.lead_model)} lead / ${escapeHtml(project.skeptic_model)} skeptic</p>
        <p>${escapeHtml(project.active_work_count)} active of ${escapeHtml(project.work_count)} work items</p>
      </div>
      <div class="project-gate">
        <span class="gate-label">Current gate</span>
        <p>${escapeHtml(project.current_gate)}</p>
        <p><strong>Next:</strong> ${escapeHtml(shortText(project.next_action, 170))}</p>
      </div>
      <div class="srl-block">
        <span class="label">SRL</span>
        <strong>${escapeHtml(project.srl)} / 9</strong>
        <div class="bar-track"><div class="bar-fill" style="width:${Math.max(0, Math.min(100, Number(project.srl) / 9 * 100))}%"></div></div>
        <p>${escapeHtml(formatTime(project.target_review))}</p>
      </div>
    </article>
  `).join("") : '<div class="empty-state">No projects registered.</div>';
}

function renderRoles(roles) {
  const overdue = roles.filter((role) => ["DUE", "OVERDUE_ACTIVE"].includes(role.status)).length;
  $("role-health").textContent = overdue ? `${overdue} overdue` : "On cadence";
  $("role-health").className = `status-pill ${overdue ? "danger" : "good"}`;
  $("role-list").classList.remove("loading-block");
  $("role-list").innerHTML = roles.length ? roles.map((role) => {
    const statusClass = `status-${cssStatus(role.status)}`;
    const cadence = role.cadence_hours ? `every ${role.cadence_hours}h` : titleCase(role.mode);
    const time = role.mode === "periodic" ? relativeTime(role.seconds_until_due) : titleCase(role.mode);
    return `
      <article class="role-row">
        <div>
          <div class="role-title-line">
            <strong>${escapeHtml(role.label)}</strong>
            <span class="status-pill ${statusClass}">${escapeHtml(role.status)}</span>
          </div>
          <p class="role-meta">${escapeHtml(cadence)}${role.model ? ` / last: ${escapeHtml(role.model)}` : ""}</p>
          ${role.artifact_path ? `<p>${repoLink(role.artifact_path, "Latest artifact")}</p>` : ""}
        </div>
        <div class="role-time">
          <strong>${escapeHtml(time)}</strong>
          <span>${escapeHtml(role.due_at ? formatTime(role.due_at) : "event gate")}</span>
        </div>
      </article>
    `;
  }).join("") : '<div class="empty-state">No role policies registered.</div>';
}

function renderChips(target, values) {
  const entries = Object.entries(values).sort((left, right) => right[1] - left[1]);
  target.innerHTML = entries.map(([label, count]) => `
    <div class="chart-chip"><span>${escapeHtml(titleCase(label))}</span><strong>${escapeHtml(count)}</strong></div>
  `).join("");
}

function renderJobs(jobs) {
  $("job-summary").textContent = `${jobs.total} registered`;
  renderChips($("job-status-chart"), jobs.statuses);
  $("job-list").classList.remove("loading-block");
  $("job-list").innerHTML = jobs.rows.length ? jobs.rows.map((job) => `
    <article class="compact-row">
      <div class="compact-title-line">
        <strong>${escapeHtml(shortText(job.title, 70))}</strong>
        <span class="status-pill status-${cssStatus(job.status)}">${escapeHtml(job.status)}</span>
      </div>
      <p>${escapeHtml(job.id)} / ${escapeHtml(job.work_item_id || "unlinked")}</p>
    </article>
  `).join("") : '<div class="empty-state">No Aristotle jobs registered.</div>';
}

function renderWork(work) {
  $("work-summary").textContent = `${work.total} total work items`;
  renderChips($("pipeline-chart"), work.pipeline);
  $("active-work-list").classList.remove("loading-block");
  $("active-work-list").innerHTML = work.active.length ? work.active.map((item) => `
    <article class="work-row">
      <div><span class="work-id">${escapeHtml(item.id)}</span><p>P${escapeHtml(item.priority)}</p></div>
      <div>
        <strong class="work-title">${escapeHtml(item.title)}</strong>
        <p>${escapeHtml(item.project_id)} / ${escapeHtml(item.role)}</p>
      </div>
      <div class="work-next">
        <span class="gate-label">Next action</span>
        <p>${escapeHtml(shortText(item.next_action, 230))}</p>
      </div>
      <div class="work-status">
        <span class="status-pill status-${cssStatus(item.status)}">${escapeHtml(item.status)}</span>
        <span class="model-pill">${escapeHtml(item.owner_model)}</span>
      </div>
    </article>
  `).join("") : '<div class="empty-state">No work items are currently executing or under review.</div>';
}

function renderClaims(claims) {
  $("claim-summary").textContent = `${claims.total} claims`;
  renderChips($("claim-chart"), claims.grades);
  $("claim-list").classList.remove("loading-block");
  $("claim-list").innerHTML = claims.latest.length ? claims.latest.map((claim) => `
    <article class="compact-row">
      <div class="compact-title-line">
        <strong>${escapeHtml(claim.id)}</strong>
        <span class="grade-pill">${escapeHtml(claim.grade)}</span>
      </div>
      <p>${escapeHtml(shortText(claim.statement, 155))}</p>
      ${claim.guard_file ? `<p>${repoLink(claim.guard_file, "Guard")}</p>` : ""}
    </article>
  `).join("") : '<div class="empty-state">No claims registered.</div>';
}

function renderCommunications(messages, availability) {
  $("message-summary").textContent = `${messages.length} requiring attention`;
  $("availability-list").innerHTML = availability.map((agent) => `
    <div class="availability-item ${cssStatus(agent.status)}" title="${escapeHtml(agent.detail || "")}">
      <strong>${escapeHtml(agent.model)}</strong>
      <span>${escapeHtml(agent.status)}</span>
    </div>
  `).join("");
  $("message-list").classList.remove("loading-block");
  $("message-list").innerHTML = messages.length ? messages.map((message) => `
    <article class="compact-row">
      <div class="compact-title-line">
        <strong>${escapeHtml(shortText(message.subject, 70))}</strong>
        <span class="priority-pill ${cssStatus(message.priority)}">${escapeHtml(message.priority)}</span>
      </div>
      <p>${escapeHtml(message.from_model)} to ${escapeHtml(message.to_model)} / ${escapeHtml(message.work_item_id || "general")}</p>
      <p>${escapeHtml(shortText(message.body, 145))}</p>
    </article>
  `).join("") : '<div class="empty-state">No open mailbox actions.</div>';
}

function renderLedger(ledger, forecasts) {
  const brier = forecasts.brier_score === null ? "not calibrated" : `Brier ${Number(forecasts.brier_score).toFixed(3)}`;
  $("forecast-summary").textContent = `${forecasts.resolved}/${forecasts.total} forecasts resolved / ${brier}`;
  $("ledger-list").classList.remove("loading-block");
  $("ledger-list").innerHTML = ledger.length ? ledger.map((entry) => `
    <article class="ledger-row">
      <strong>${escapeHtml(entry.heading)}</strong>
      <p>${escapeHtml(entry.summary)}</p>
    </article>
  `).join("") : '<div class="empty-state">No ledger entries found.</div>';
}

function renderValidation(validation, watermark) {
  const indicator = $("validation-indicator");
  indicator.className = `health-dot ${validation.ok ? "good" : "danger"}`;
  $("validation-text").textContent = validation.ok
    ? "All machine-readable lab registries validate"
    : `${validation.errors.length} state validation error(s)`;
  $("validation-text").title = validation.errors.join("\n");
  $("watermark").textContent = `Watermark ${String(watermark).slice(0, 12)}`;
}

function renderAlert(data) {
  const alerts = [];
  if (!data.validation.ok) alerts.push(`${data.validation.errors.length} registry validation error(s)`);
  if (data.kpis.overdue_roles) alerts.push(`${data.kpis.overdue_roles} role duty or activation overdue`);
  if (data.kpis.blocked_work) alerts.push(`${data.kpis.blocked_work} work item(s) blocked`);
  const bar = $("alert-bar");
  if (!alerts.length) {
    bar.classList.add("hidden");
    bar.textContent = "";
    return;
  }
  bar.textContent = `Attention: ${alerts.join(" / ")}`;
  bar.classList.remove("hidden");
}

function render(data) {
  const cycle = data.lab.cycle || {};
  const executionMode = data.lab.execution_mode || { kind: "collaborative" };
  const modeLabel = executionMode.kind === "solo"
    ? `Solo: ${titleCase(executionMode.active_model)}`
    : "Collaborative";
  $("cycle-id").textContent = cycle.id || "No cycle";
  $("cycle-phase").textContent = `${titleCase(cycle.phase)} / ${titleCase(cycle.status)} / ${modeLabel}`;
  $("north-star-title").textContent = data.lab.north_star || "No north star registered";
  $("release-state").textContent = titleCase(data.lab.release_state);
  $("release-control").textContent = data.lab.human_release_required ? "Human approval required" : "Automated release permitted";
  $("last-refresh").textContent = `Updated ${new Date(data.meta.generated_at).toLocaleTimeString()}`;
  renderKpis(data.kpis);
  renderProjects(data.projects);
  renderRoles(data.roles);
  renderJobs(data.jobs);
  renderWork(data.work);
  renderClaims(data.claims);
  renderCommunications(data.messages, data.availability);
  renderLedger(data.ledger, data.forecasts);
  renderValidation(data.validation, data.meta.watermark);
  renderAlert(data);
}

async function refresh() {
  if (state.loading) return;
  state.loading = true;
  $("refresh-button").classList.add("refreshing");
  try {
    const response = await fetch("/api/state", { cache: "no-store" });
    if (!response.ok) throw new Error(`Dashboard API returned ${response.status}`);
    render(await response.json());
  } catch (error) {
    const bar = $("alert-bar");
    bar.textContent = `Dashboard connection failed: ${error.message}`;
    bar.classList.remove("hidden");
    $("last-refresh").textContent = "Connection failed";
  } finally {
    state.loading = false;
    $("refresh-button").classList.remove("refreshing");
  }
}

function scheduleRefresh() {
  if (state.timer) window.clearInterval(state.timer);
  state.timer = window.setInterval(refresh, state.refreshSeconds * 1000);
}

function updateClock() {
  $("local-clock").textContent = new Date().toLocaleTimeString([], {
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
  });
}

$("refresh-rate").value = String(state.refreshSeconds);
$("refresh-rate").addEventListener("change", (event) => {
  state.refreshSeconds = Number(event.target.value);
  localStorage.setItem("afpl-refresh-seconds", String(state.refreshSeconds));
  scheduleRefresh();
});
$("refresh-button").addEventListener("click", refresh);

updateClock();
window.setInterval(updateClock, 1000);
scheduleRefresh();
refresh();
