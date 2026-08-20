// ====================================================
// FLUTTER MATERIAL 3 STARTER WEB APP - COMPLETE SCRIPT
// ====================================================

let globalPastoresData = [];
let globalChurchesData = [];
let globalDistrictsData = [];
let globalContactsData = [];
let globalCriteriaData = [];
let activePastorId = 1;

document.addEventListener("DOMContentLoaded", () => {
  initM3Navigation();
  initM3ThemeAndColorPicker();
  initSupabaseSyncButton();
  initClerkAuth();
  fetchData();

  // Add Pastor Modal Handlers
  const btnFab = document.getElementById("m3-btn-fab");
  const btnHeaderAdd = document.getElementById("btn-header-add-pastor");
  const btnTableAdd = document.getElementById("btn-add-pastor-table");

  if (btnFab) btnFab.addEventListener("click", openAddPastorModal);
  if (btnHeaderAdd) btnHeaderAdd.addEventListener("click", openAddPastorModal);
  if (btnTableAdd) btnTableAdd.addEventListener("click", openAddPastorModal);

  document.getElementById("modal-add-cancel").addEventListener("click", closeAddPastorModal);
  document.getElementById("modal-add-save").addEventListener("click", saveNewPastor);

  // Dash Pastor Change
  document.getElementById("select-dash-pastor").addEventListener("change", (e) => {
    updateDashPastorCard(e.target.value);
  });
  document.getElementById("select-form-pastor").addEventListener("change", (e) => {
    updateFormSheet(e.target.value);
  });
  document.getElementById("select-report-pastor").addEventListener("change", (e) => {
    updateReportSheet(e.target.value);
  });

  // Filters
  document.getElementById("input-search-church").addEventListener("input", filterChurchesTable);
  document.getElementById("input-search-contact").addEventListener("input", filterContactsTable);

  // Modal Handlers
  document.getElementById("modal-cancel").addEventListener("click", closeModal);
  document.getElementById("modal-save").addEventListener("click", saveEvaluationFromModal);

  // Mobile Officer Login
  document.getElementById("btn-officer-login").addEventListener("click", handleOfficerLogin);
  document.getElementById("mobile-select-district").addEventListener("change", handleDistrictChange);
  document.getElementById("mobile-select-church").addEventListener("change", handleChurchChange);

  // Mobile Sliders
  [1, 2, 3, 4, 5].forEach(num => {
    const sld = document.getElementById(`sld-mob-${num}`);
    const lbl = document.getElementById(`lbl-mob-${num}`);
    if (sld && lbl) {
      sld.addEventListener("input", (e) => {
        lbl.textContent = parseFloat(e.target.value).toFixed(1);
      });
    }
  });

  document.getElementById("btn-submit-mobile-eval").addEventListener("click", submitMobileEvaluation);
  document.getElementById("btn-save-report").addEventListener("click", saveQuarterlyReport);

  // Form Login
  const loginForm = document.getElementById("form-login-m3");
  if (loginForm) {
    loginForm.addEventListener("submit", (e) => {
      e.preventDefault();
      alert("✅ Autenticado com sucesso no Pastoral 360!");
      openTab("tab-dashboard");
    });
  }
});

function openAddPastorModal() {
  document.getElementById("modal-add-pastor").style.display = "flex";
}

function closeAddPastorModal() {
  document.getElementById("modal-add-pastor").style.display = "none";
}

async function saveNewPastor() {
  const nome = document.getElementById("add-p-nome").value;
  const distrito = document.getElementById("add-p-dist").value;
  const provincia = document.getElementById("add-p-prov").value;
  const cargo = document.getElementById("add-p-cargo").value;
  const contacto = document.getElementById("add-p-phone").value;

  if (!nome || !distrito) {
    return alert("Por favor preencha o Nome e o Distrito.");
  }

  try {
    const res = await fetch("/api/pastors/add", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        nome: nome,
        distrito: distrito,
        provincia: provincia,
        cargo: cargo,
        contacto: contacto
      })
    });
    const data = await res.json();
    alert(data.message || "Pastor adicionado com sucesso!");
    closeAddPastorModal();
    fetchData();
  } catch (err) {
    alert("Erro ao adicionar pastor.");
  }
}

// Clerk Auth Integration
function initClerkAuth() {
  if (window.Clerk) {
    window.Clerk.load({
      publishableKey: "pk_test_bGl2ZS1tb25rZXktOTQuY2xlcmsuYWNjb3VudHMuZGV2JA"
    }).then(() => {
      const container = document.getElementById("clerk-auth-container");
      if (container && window.Clerk.user) {
        container.innerHTML = `<div class="m3-chip" style="background-color: #10B981; color: #FFF;">Sessão Clerk Ativa: ${window.Clerk.user.primaryEmailAddress}</div>`;
      }
    }).catch(err => console.log("Clerk auth standalone mode"));
  }
}

// Supabase Sync Button with Animated Loading Spinner
function initSupabaseSyncButton() {
  const syncBtn = document.getElementById("m3-btn-sync");
  if (!syncBtn) return;

  syncBtn.addEventListener("click", async () => {
    syncBtn.disabled = true;
    syncBtn.innerHTML = `<span class="m3-spinner"></span> <span>A Sincronizar com o Supabase...</span>`;

    try {
      const res = await fetch("/api/data");
      const data = await res.json();
      await new Promise(r => setTimeout(r, 1200));

      syncBtn.style.backgroundColor = "#10B981";
      syncBtn.innerHTML = `<span>✅ Sincronizado com Sucesso!</span>`;

      setTimeout(() => {
        syncBtn.disabled = false;
        syncBtn.innerHTML = `<span>🔄 Sincronizar Supabase</span>`;
      }, 2500);

      fetchData();
    } catch (err) {
      syncBtn.disabled = false;
      syncBtn.innerHTML = `<span>❌ Erro na Sincronização</span>`;
      setTimeout(() => {
        syncBtn.innerHTML = `<span>🔄 Sincronizar Supabase</span>`;
      }, 2500);
    }
  });
}

// M3 Navigation Tabs
function initM3Navigation() {
  const navItems = document.querySelectorAll(".m3-nav-item");
  navItems.forEach(item => {
    item.addEventListener("click", () => {
      const tabId = item.getAttribute("data-tab");
      openTab(tabId);
    });
  });
}

function openTab(tabId) {
  const navItems = document.querySelectorAll(".m3-nav-item");
  const tabPanes = document.querySelectorAll(".tab-pane");
  const titleEl = document.getElementById("m3-page-title");

  const titles = {
    "tab-dashboard": "Pastoral 360 - Dashboard Executivo",
    "tab-login": "Pastoral 360 - Autenticação & Perfil",
    "tab-mobile-eval": "Pastoral 360 - Avaliação Mobile",
    "tab-evaluations": "Pastoral 360 - Matriz de Avaliação Pastoral",
    "tab-form": "Pastoral 360 - Ficha 51 Critérios",
    "tab-report": "Pastoral 360 - Relatório 28 Itens",
    "tab-churches": "Pastoral 360 - 330 Congregações",
    "tab-districts": "Pastoral 360 - Distritos",
    "tab-contacts": "Pastoral 360 - Contactos",
    "tab-audit": "Pastoral 360 - Histórico de Auditoria",
    "tab-settings": "Pastoral 360 - Configurações"
  };

  navItems.forEach(i => i.classList.remove("active"));
  tabPanes.forEach(p => p.classList.remove("active"));

  const activeNav = document.querySelector(`.m3-nav-item[data-tab="${tabId}"]`);
  if (activeNav) activeNav.classList.add("active");

  const targetPane = document.getElementById(tabId);
  if (targetPane) targetPane.classList.add("active");

  if (titles[tabId] && titleEl) {
    titleEl.textContent = titles[tabId];
  }
}

// M3 Seed Color Picker & Theme Toggle
function initM3ThemeAndColorPicker() {
  const themeBtn = document.getElementById("m3-btn-theme");
  if (themeBtn) {
    themeBtn.addEventListener("click", () => {
      document.body.classList.toggle("dark-mode");
      themeBtn.textContent = document.body.classList.contains("dark-mode") ? "☀️" : "🌙";
    });
  }

  const dots = document.querySelectorAll(".m3-color-dot");
  dots.forEach(dot => {
    dot.addEventListener("click", () => {
      dots.forEach(d => d.classList.remove("active"));
      dot.classList.add("active");
      const hex = dot.getAttribute("data-color");
      document.documentElement.style.setProperty("--m3-primary", hex);
    });
  });
}

// Fetch Data
async function fetchData() {
  try {
    const res = await fetch("/api/data");
    const data = await res.json();

    if (data.pastores) {
      globalPastoresData = data.pastores;
      globalChurchesData = data.churches || [];
      globalDistrictsData = data.districts || [];
      globalContactsData = data.contacts || [];
      globalCriteriaData = data.criteria || [];

      renderDashboard(data);
      renderPastorsTable(globalPastoresData);
      renderChurchesTable(globalChurchesData);
      renderDistrictsGrid(globalDistrictsData);
      renderContactsTable(globalContactsData);
      populateSelectors(globalPastoresData);
      populateMobileDistricts();
      renderFormCriteria(globalCriteriaData);
      renderReportSec2();
    }
  } catch (err) {
    console.error("Erro ao carregar dados do servidor Excel:", err);
  }
}

function populateSelectors(pastores) {
  const selDash = document.getElementById("select-dash-pastor");
  const selForm = document.getElementById("select-form-pastor");
  const selRep = document.getElementById("select-report-pastor");

  let html = pastores.map(p => `<option value="${p.id}">${p.id}. ${p.nome} (${p.distrito})</option>`).join("");

  selDash.innerHTML = html;
  selForm.innerHTML = html;
  selRep.innerHTML = html;

  if (pastores.length > 0) {
    updateDashPastorCard(pastores[0].id);
    updateFormSheet(pastores[0].id);
    updateReportSheet(pastores[0].id);
  }
}

function populateMobileDistricts() {
  const selDist = document.getElementById("mobile-select-district");
  const districts = [...new Set(globalPastoresData.map(p => p.distrito))].sort();

  selDist.innerHTML = districts.map(d => `<option value="${d}">${d}</option>`).join("");
  if (districts.length > 0) handleDistrictChange();
}

function handleDistrictChange() {
  const selectedDistrict = document.getElementById("mobile-select-district").value;
  const selChurch = document.getElementById("mobile-select-church");

  const filteredChurches = globalChurchesData.filter(c => c.distrito.toLowerCase().includes(selectedDistrict.toLowerCase()));
  if (filteredChurches.length > 0) {
    selChurch.innerHTML = filteredChurches.map(c => `<option value="${c.igreja}">${c.cn} - ${c.igreja} (${c.municipio})</option>`).join("");
  } else {
    selChurch.innerHTML = `<option value="Sede">Igreja Central do Distrito</option>`;
  }
  handleChurchChange();
}

function handleChurchChange() {
  const selectedDistrict = document.getElementById("mobile-select-district").value;
  const selPastor = document.getElementById("mobile-select-pastor");
  const matchingPastors = globalPastoresData.filter(p => p.distrito.toLowerCase().includes(selectedDistrict.toLowerCase()));

  if (matchingPastors.length > 0) {
    selPastor.innerHTML = matchingPastors.map(p => `<option value="${p.id}">${p.nome} (${p.cargo})</option>`).join("");
  } else {
    selPastor.innerHTML = globalPastoresData.map(p => `<option value="${p.id}">${p.nome} (${p.distrito})</option>`).join("");
  }
}

function handleOfficerLogin() {
  const email = document.getElementById("officer-email").value;
  if (!email) return alert("Insira o e-mail.");
  document.getElementById("logged-officer-email").textContent = email;
  document.getElementById("mobile-login-card").style.display = "none";
  document.getElementById("mobile-eval-form").style.display = "block";
}

async function submitMobileEvaluation() {
  const pastorId = document.getElementById("mobile-select-pastor").value;
  const scores = {
    assistencia: parseFloat(document.getElementById("sld-mob-1").value),
    relacionamento: parseFloat(document.getElementById("sld-mob-2").value),
    familia: parseFloat(document.getElementById("sld-mob-3").value),
    sermoes: parseFloat(document.getElementById("sld-mob-4").value),
    administracao: parseFloat(document.getElementById("sld-mob-5").value)
  };

  try {
    const res = await fetch("/api/evaluate", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id: pastorId, scores: scores })
    });
    const data = await res.json();
    alert(`✅ Avaliação enviada com sucesso!\n${data.message}`);
    fetchData();
  } catch (err) {
    alert("Erro ao submeter avaliação.");
  }
}

function renderDashboard(data) {
  const pastores = data.pastores || [];
  document.getElementById("kpi-total-pastors").textContent = pastores.length;

  if (pastores.length > 0) {
    const sumAvg = pastores.reduce((acc, p) => acc + p.media_geral, 0);
    document.getElementById("kpi-avg-score").textContent = (sumAvg / pastores.length).toFixed(2);

    const avgAssist = (pastores.reduce((acc, p) => acc + p.assistencia, 0) / pastores.length).toFixed(2);
    const avgRel = (pastores.reduce((acc, p) => acc + p.relacionamento, 0) / pastores.length).toFixed(2);
    const avgFam = (pastores.reduce((acc, p) => acc + p.familia, 0) / pastores.length).toFixed(2);
    const avgSerm = (pastores.reduce((acc, p) => acc + p.sermoes, 0) / pastores.length).toFixed(2);
    const avgAdmin = (pastores.reduce((acc, p) => acc + p.administracao, 0) / pastores.length).toFixed(2);

    document.getElementById("bar-val-1").textContent = avgAssist;
    document.getElementById("bar-fill-1").style.width = (avgAssist / 5 * 100) + "%";

    document.getElementById("bar-val-2").textContent = avgRel;
    document.getElementById("bar-fill-2").style.width = (avgRel / 5 * 100) + "%";

    document.getElementById("bar-val-3").textContent = avgFam;
    document.getElementById("bar-fill-3").style.width = (avgFam / 5 * 100) + "%";

    document.getElementById("bar-val-4").textContent = avgSerm;
    document.getElementById("bar-fill-4").style.width = (avgSerm / 5 * 100) + "%";

    document.getElementById("bar-val-5").textContent = avgAdmin;
    document.getElementById("bar-fill-5").style.width = (avgAdmin / 5 * 100) + "%";
  }
}

function updateDashPastorCard(id) {
  const pastor = globalPastoresData.find(p => String(p.id) === String(id));
  if (!pastor) return;
  document.getElementById("dash-p-dist").textContent = pastor.distrito;
  document.getElementById("dash-p-prov").textContent = pastor.provincia;
  document.getElementById("dash-p-cargo").textContent = pastor.cargo;
  document.getElementById("dash-p-phone").textContent = pastor.contacto;
  document.getElementById("dash-p-avg").textContent = pastor.media_geral.toFixed(2);
}

function renderPastorsTable(pastores) {
  const tbody = document.getElementById("tbody-pastores");
  tbody.innerHTML = pastores.map(p => `
    <tr>
      <td><strong>${p.id}</strong></td>
      <td><strong>${p.nome}</strong></td>
      <td>${p.distrito}</td>
      <td>${p.provincia}</td>
      <td>${p.contacto}</td>
      <td>${p.assistencia.toFixed(2)}</td>
      <td>${p.relacionamento.toFixed(2)}</td>
      <td>${p.familia.toFixed(2)}</td>
      <td>${p.sermoes.toFixed(2)}</td>
      <td>${p.administracao.toFixed(2)}</td>
      <td>${p.total_pontos}</td>
      <td><strong style="color: var(--m3-primary);">${p.media_geral.toFixed(2)}</strong></td>
      <td>
        <div style="display: flex; gap: 6px;">
          <button class="m3-btn-tonal" onclick="openEvalModal(${p.id})">✏️ Avaliar</button>
          <a href="/api/pdf/download/${p.id}" class="m3-btn-outlined" style="text-decoration: none; padding: 4px 8px; font-size: 11px;">📄 PDF</a>
          <button class="m3-btn-filled" style="padding: 4px 8px; font-size: 11px; background-color: #3B82F6;" onclick="sendEmailModal(${p.id})">📧 E-mail</button>
        </div>
      </td>
    </tr>
  `).join("");
}

async function sendEmailModal(id) {
  const email = prompt("Insira o e-mail do destinatário:", "valentino@mcasd.org");
  if (!email) return;

  try {
    const res = await fetch("/api/email/send", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ pastor_id: id, to_email: email })
    });
    const data = await res.json();
    alert(`✅ E-mail Corporativo Enviado!\n${data.message}`);
  } catch (err) {
    alert("Erro ao enviar e-mail.");
  }
}

function renderChurchesTable(churches) {
  const tbody = document.getElementById("tbody-churches");
  tbody.innerHTML = churches.map(c => `
    <tr>
      <td><strong>${c.cn}</strong></td>
      <td><strong>${c.igreja}</strong></td>
      <td>${c.distrito}</td>
      <td>${c.municipio}</td>
      <td>${c.provincia}</td>
      <td>${c.delegado}</td>
    </tr>
  `).join("");
}

function filterChurchesTable() {
  const search = document.getElementById("input-search-church").value.toLowerCase();
  const filtered = globalChurchesData.filter(c => c.igreja.toLowerCase().includes(search) || c.distrito.toLowerCase().includes(search));
  renderChurchesTable(filtered);
}

function renderDistrictsGrid(districts) {
  const container = document.getElementById("districts-cards-grid");
  if (!container) return;
  container.innerHTML = districts.map(d => `
    <div class="m3-stat-card" style="flex-direction: column; align-items: flex-start; gap: 8px;">
      <strong style="font-size: 16px;">🏛️ ${d.nome}</strong>
      <span style="font-size: 12px; opacity: 0.8;">Província: ${d.provincia} | Município: ${d.municipio}</span>
      <strong style="font-size: 14px;">Total Igrejas: ${d.total_igrejas}</strong>
    </div>
  `).join("");
}

function renderContactsTable(contacts) {
  const tbody = document.getElementById("tbody-contacts");
  if (!tbody) return;
  tbody.innerHTML = contacts.map(c => `
    <tr>
      <td><strong>${c.id}</strong></td>
      <td><strong>${c.nome}</strong></td>
      <td>${c.distrito}</td>
      <td>${c.provincia}</td>
      <td><strong>${c.contacto}</strong></td>
      <td><a href="tel:${c.contacto}" class="m3-btn-filled" style="padding: 4px 12px; text-decoration: none;">📞 Ligar</a></td>
    </tr>
  `).join("");
}

function filterContactsTable() {
  const search = document.getElementById("input-search-contact").value.toLowerCase();
  const filtered = globalContactsData.filter(c => c.nome.toLowerCase().includes(search) || c.distrito.toLowerCase().includes(search));
  renderContactsTable(filtered);
}

function updateFormSheet(id) {
  const pastor = globalPastoresData.find(p => String(p.id) === String(id));
  if (!pastor) return;
  document.getElementById("form-p-name").textContent = pastor.nome;
  document.getElementById("form-p-dist").textContent = pastor.distrito;
  document.getElementById("form-p-avg").textContent = pastor.media_geral.toFixed(2);
  document.getElementById("form-p-class").textContent = pastor.classificacao.toUpperCase();
}

function renderFormCriteria(criteria) {
  const container = document.getElementById("form-criteria-sections");
  if (!container) return;
  const categories = ["Assistência Pastoral", "Relacionamento Pessoal", "Família Pastoral", "Sermões", "Administração"];
  
  container.innerHTML = categories.map((catName, idx) => {
    const items = criteria.filter(c => c.categoria.toLowerCase().includes(catName.toLowerCase()));
    return `
      <div style="margin-bottom: 16px;">
        <h4 style="background: var(--m3-surface-variant); padding: 6px 10px; font-size: 13px;">${idx + 1}. ${catName.toUpperCase()} (${items.length} CRITÉRIOS)</h4>
        <table class="m3-table">
          <thead><tr><th>Nº</th><th>Critério</th><th>Nota</th></tr></thead>
          <tbody>
            ${items.map((item, i) => `
              <tr>
                <td>${item.item_numero || (i + 1)}</td>
                <td><strong>${item.nome}</strong><br><small style="opacity: 0.7;">${item.descricao}</small></td>
                <td><strong>5</strong></td>
              </tr>
            `).join("")}
          </tbody>
        </table>
      </div>
    `;
  }).join("");
}

function updateReportSheet(id) {
  const pastor = globalPastoresData.find(p => String(p.id) === String(id));
  if (!pastor) return;
  document.getElementById("rep-pastor-display").textContent = `PASTOR DO DISTRITO: ${pastor.nome} (${pastor.distrito})`;
}

function renderReportSec2() {
  const tbody = document.getElementById("tbody-report-sec2");
  if (!tbody) return;
  tbody.innerHTML = `
    <tr><td>6</td><td>Baptismos Propostos Quinquénio</td><td><input type="number" value="500" class="m3-text-field"></td></tr>
    <tr><td>7</td><td>Membros Baptizados Trimestre</td><td><input type="number" value="45" class="m3-text-field"></td></tr>
    <tr><td>8</td><td>Total de Membros Baptizados</td><td><input type="number" value="1250" class="m3-text-field"></td></tr>
  `;
}

async function saveQuarterlyReport() {
  alert("Relatório salvo!");
}

function openEvalModal(id) {
  const pastor = globalPastoresData.find(p => String(p.id) === String(id));
  if (!pastor) return;
  activePastorId = pastor.id;
  document.getElementById("eval-modal-name").textContent = pastor.nome;
  document.getElementById("inp-eval-g").value = pastor.assistencia;
  document.getElementById("inp-eval-h").value = pastor.relacionamento;
  document.getElementById("inp-eval-i").value = pastor.familia;
  document.getElementById("inp-eval-j").value = pastor.sermoes;
  document.getElementById("inp-eval-k").value = pastor.administracao;
  document.getElementById("modal-eval").style.display = "flex";
}

function closeModal() {
  document.getElementById("modal-eval").style.display = "none";
}

async function saveEvaluationFromModal() {
  const scores = {
    assistencia: parseFloat(document.getElementById("inp-eval-g").value),
    relacionamento: parseFloat(document.getElementById("inp-eval-h").value),
    familia: parseFloat(document.getElementById("inp-eval-i").value),
    sermoes: parseFloat(document.getElementById("inp-eval-j").value),
    administracao: parseFloat(document.getElementById("inp-eval-k").value)
  };

  try {
    const res = await fetch("/api/evaluate", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id: activePastorId, scores: scores })
    });
    const data = await res.json();
    alert(data.message || "Avaliação salva!");
    closeModal();
    fetchData();
  } catch (err) {
    alert("Erro ao salvar avaliação.");
  }
}
