// Clase principal de la aplicación
class BitacoraApp {
    constructor() {
        this.meetings = [];
        this.departments = [];
        this.init();
    }

    async init() {
        this.showLoader(true);
        this.setupEventListeners();
        await this.loadMeetings();
        await this.updateDepartmentFilter();
        this.showLoader(false);
    }

    showLoader(show) {
        const loader = document.getElementById('loader');
        if (show) {
            loader.classList.remove('hidden');
        } else {
            loader.classList.add('hidden');
        }
    }

    setupEventListeners() {
        const uploadArea = document.getElementById('uploadArea');
        const fileInput = document.getElementById('fileInput');

        // Drag and drop
        uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', () => {
            uploadArea.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadArea.classList.remove('dragover');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                this.handleFile(files[0]);
            }
        });

        uploadArea.addEventListener('click', () => {
            fileInput.click();
        });

        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                this.handleFile(e.target.files[0]);
            }
        });

        // Filtros
        document.getElementById('searchInput').addEventListener('input', () => this.filterMeetings());
        document.getElementById('departmentFilter').addEventListener('change', () => this.filterMeetings());
        document.getElementById('dateFilter').addEventListener('change', () => this.filterMeetings());

        // Cerrar modal al hacer clic fuera
        window.onclick = (event) => {
            const modal = document.getElementById('meetingModal');
            if (event.target === modal) {
                this.closeModal();
            }
        };
    }

    async handleFile(file) {
        const reader = new FileReader();
        reader.onload = async (e) => {
            const content = e.target.result;
            const meeting = this.parseTranscript(content);
            
            if (meeting) {
                try {
                    this.showNotification('Subiendo reunión...', 'info');
                    
                    // Guardar en Supabase
                    await window.db.createMeeting(meeting);
                    
                    // Recargar reuniones
                    await this.loadMeetings();
                    await this.updateDepartmentFilter();
                    
                    this.showNotification('¡Reunión agregada exitosamente!', 'success');
                    
                    // Limpiar el input
                    document.getElementById('fileInput').value = '';
                } catch (error) {
                    this.showNotification('Error al guardar la reunión', 'error');
                    console.error(error);
                }
            }
        };
        reader.readAsText(file);
    }

    parseTranscript(content) {
        const meeting = {
            rawContent: content
        };

        // Extraer título
        const titleMatch = content.match(/# ANÁLISIS DE TRANSCRIPCIÓN[^-]*-\s*(.+)/i);
        if (titleMatch) {
            meeting.title = titleMatch[1]
                .replace(/LEVANTAMIENTO DE PROCESOS LIPU\s*-\s*/i, '')
                .trim();
        }

        // Extraer información del resumen ejecutivo
        const executiveSummaryMatch = content.match(/##\s*1\.\s*RESUMEN EJECUTIVO([\s\S]*?)(?=---|\n##\s*2\.)/i);
        if (executiveSummaryMatch) {
            const summaryContent = executiveSummaryMatch[1];
            
            // Fecha
            const dateMatch = summaryContent.match(/(?:Fecha y hora)[:\s]*([^\n]+)/i);
            if (dateMatch) {
                meeting.date = dateMatch[1].trim();
            }

            // Participantes
            const participantsMatch = summaryContent.match(/\*\*Participantes:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)/i);
            if (participantsMatch) {
                meeting.participants = participantsMatch[1]
                    .split('\n')
                    .filter(line => line.trim().startsWith('-'))
                    .map(line => line.replace(/^-\s*/, '').trim())
                    .filter(p => p.length > 0);
            }

            // Departamento
            const deptMatch = summaryContent.match(/\*\*Área o departamento analizado:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)/i);
            if (deptMatch) {
                const deptLines = deptMatch[1]
                    .split('\n')
                    .filter(line => line.trim().startsWith('-'))
                    .map(line => line.replace(/^-\s*/, '').trim())
                    .filter(d => d.length > 0);
                
                if (deptLines.length > 0) {
                    meeting.department = deptLines.join(', ');
                }
            }

            // Objetivo
            const objMatch = summaryContent.match(/\*\*Objetivo principal[^:]*:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)/i);
            if (objMatch) {
                const objLines = objMatch[1]
                    .split('\n')
                    .filter(line => line.trim().startsWith('-'))
                    .map(line => line.replace(/^-\s*/, '').trim())
                    .filter(o => o.length > 0);
                
                meeting.objective = objLines.join(', ');
            }

            // Conclusiones
            const conclusionsMatch = summaryContent.match(/\*\*Conclusiones clave:\*\*([\s\S]*?)$/i);
            if (conclusionsMatch) {
                meeting.conclusions = conclusionsMatch[1]
                    .split('\n')
                    .filter(line => /^\d+\./.test(line.trim()))
                    .map(line => line.trim());
            }
        }

        // Contar procesos
        const processTableMatch = content.match(/##\s*2\.\s*PROCESOS IDENTIFICADOS([\s\S]*?)(?=---|\n##\s*3\.)/i);
        if (processTableMatch) {
            const tableContent = processTableMatch[1];
            const rows = tableContent.split('\n').filter(line => 
                line.includes('|') && 
                !line.includes('Nombre del Proceso') && 
                !line.match(/^\s*\|?\s*[-]+/)
            );
            meeting.processCount = rows.length;
        }

        // Contar sistemas
        const systemsMatch = content.match(/##\s*4\.\s*SISTEMAS Y HERRAMIENTAS([\s\S]*?)(?=---|\n##\s*5\.)/i);
        if (systemsMatch) {
            const systemsContent = systemsMatch[1];
            const rows = systemsContent.split('\n').filter(line => 
                line.includes('|') && 
                !line.includes('Sistema') && 
                !line.match(/^\s*\|?\s*[-]+/)
            );
            meeting.systemCount = rows.length;
        }

        // Contar hallazgos
        const findingsMatch = content.match(/##\s*6\.\s*HALLAZGOS IMPORTANTES([\s\S]*?)(?=---|\n##\s*7\.)/i);
        if (findingsMatch) {
            const findingsContent = findingsMatch[1];
            const subsections = findingsContent.match(/###\s+[^:]+:/g) || [];
            meeting.findingCount = subsections.length;
        }

        return meeting;
    }

    async loadMeetings() {
        try {
            this.meetings = await window.db.getMeetings();
            this.renderTimeline();
            await this.updateStats();
        } catch (error) {
            this.showNotification('Error al cargar reuniones', 'error');
            console.error(error);
        }
    }

    renderTimeline() {
        const timeline = document.getElementById('timeline');
        const filteredMeetings = this.getFilteredMeetings();
        
        if (filteredMeetings.length === 0) {
            timeline.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>No hay reuniones</h3>
                    <p>Carga tu primera reunión para comenzar</p>
                </div>
            `;
            return;
        }

        timeline.innerHTML = '';
        
        filteredMeetings.forEach((meeting, index) => {
            const item = document.createElement('div');
            item.className = 'timeline-item';
            item.style.animationDelay = `${index * 0.1}s`;

            const dot = document.createElement('div');
            dot.className = 'timeline-dot';

            const content = document.createElement('div');
            content.className = 'timeline-content';

            // Contar participantes
            const participantCount = meeting.participants ? meeting.participants.length : 0;

            content.innerHTML = `
                <button class="delete-btn" onclick="app.deleteMeeting(${meeting.id}, event)" title="Eliminar reunión">
                    🗑️
                </button>
                <div class="meeting-header" onclick="app.showMeetingDetails(${meeting.id})">
                    <div>
                        <div class="meeting-title">${meeting.title || meeting.department || 'Sin título'}</div>
                        <div class="meeting-date">${meeting.date || 'Sin fecha'}</div>
                    </div>
                </div>
                <div class="meeting-objective" onclick="app.showMeetingDetails(${meeting.id})">
                    ${meeting.objective || 'Sin objetivo definido'}
                </div>
                <div class="meeting-stats">
                    <div class="stat">
                        <div class="stat-icon">👥</div>
                        <span>${participantCount} participantes</span>
                    </div>
                    <div class="stat">
                        <div class="stat-icon">⚙️</div>
                        <span>${meeting.process_count || 0} procesos</span>
                    </div>
                    <div class="stat">
                        <div class="stat-icon">💻</div>
                        <span>${meeting.system_count || 0} sistemas</span>
                    </div>
                </div>
            `;

            item.appendChild(dot);
            item.appendChild(content);
            timeline.appendChild(item);
        });
    }

    async deleteMeeting(meetingId, event) {
        event.stopPropagation();
        
        if (confirm('¿Estás seguro de que quieres eliminar esta reunión?')) {
            try {
                await window.db.deleteMeeting(meetingId);
                await this.loadMeetings();
                await this.updateDepartmentFilter();
                this.showNotification('Reunión eliminada', 'success');
            } catch (error) {
                this.showNotification('Error al eliminar la reunión', 'error');
                console.error(error);
            }
        }
    }

    showMeetingDetails(meetingId) {
        const meeting = this.meetings.find(m => m.id === meetingId);
        if (!meeting) return;

        const modal = document.getElementById('meetingModal');
        const modalTitle = document.getElementById('modalTitle');
        const modalBody = document.getElementById('modalBody');

        modalTitle.innerHTML = `
            <span style="font-size: 28px; margin-right: 10px;">📋</span> 
            ${meeting.title || meeting.department || 'Reunión de Análisis'}
        `;
        
        // Aquí puedes agregar el código para mostrar el contenido completo
        // Por ahora mostramos un resumen simple
        modalBody.innerHTML = `
            <div class="section">
                <h3 class="section-title">
                    <span class="section-icon">📊</span>
                    Resumen Ejecutivo
                </h3>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Fecha</div>
                        <div>${meeting.date || 'No especificada'}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Departamento</div>
                        <div>${meeting.department || 'No especificado'}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Objetivo</div>
                        <div>${meeting.objective || 'No especificado'}</div>
                    </div>
                </div>
                ${meeting.participants && meeting.participants.length > 0 ? `
                    <div class="info-item" style="margin-top: 20px;">
                        <div class="info-label">Participantes</div>
                        <ul>
                            ${meeting.participants.map(p => `<li>${p.name}</li>`).join('')}
                        </ul>
                    </div>
                ` : ''}
                ${meeting.conclusions && meeting.conclusions.length > 0 ? `
                    <div class="info-item" style="margin-top: 20px;">
                        <div class="info-label">Conclusiones</div>
                        <ol>
                            ${meeting.conclusions
                                .sort((a, b) => a.order_index - b.order_index)
                                .map(c => `<li>${c.conclusion.replace(/^\d+\.\s*/, '')}</li>`)
                                .join('')}
                        </ol>
                    </div>
                ` : ''}
            </div>
            
            <div class="section">
                <h3 class="section-title">
                    <span class="section-icon">📄</span>
                    Contenido Completo
                </h3>
                <div style="white-space: pre-wrap; font-family: monospace; background: #f5f5f5; padding: 20px; border-radius: 8px; max-height: 400px; overflow-y: auto;">
                    ${this.escapeHtml(meeting.raw_content)}
                </div>
            </div>
        `;

        modal.style.display = 'block';
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    closeModal() {
        document.getElementById('meetingModal').style.display = 'none';
    }

    filterMeetings() {
        this.renderTimeline();
    }

    getFilteredMeetings() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const department = document.getElementById('departmentFilter').value;
        const date = document.getElementById('dateFilter').value;

        return this.meetings.filter(meeting => {
            const matchSearch = !search || 
                meeting.raw_content.toLowerCase().includes(search) ||
                (meeting.department && meeting.department.toLowerCase().includes(search)) ||
                (meeting.title && meeting.title.toLowerCase().includes(search));
            
            const matchDepartment = !department || meeting.department === department;
            
            const matchDate = !date || (meeting.date && meeting.date.includes(date));

            return matchSearch && matchDepartment && matchDate;
        });
    }

    async updateStats() {
        try {
            const stats = await window.db.getStats();
            document.getElementById('totalMeetings').textContent = stats.totalMeetings;
            document.getElementById('totalProcesses').textContent = stats.totalProcesses;
            document.getElementById('totalSystems').textContent = stats.totalSystems;
            document.getElementById('totalFindings').textContent = stats.totalFindings;
        } catch (error) {
            console.error('Error al actualizar estadísticas:', error);
        }
    }

    async updateDepartmentFilter() {
        try {
            const departments = await window.db.getDepartments();
            const select = document.getElementById('departmentFilter');
            
            select.innerHTML = '<option value="">Todos los departamentos</option>';
            
            departments.forEach(dept => {
                const option = document.createElement('option');
                option.value = dept;
                option.textContent = dept;
                select.appendChild(option);
            });
        } catch (error) {
            console.error('Error al actualizar filtro de departamentos:', error);
        }
    }

    showNotification(message, type = 'info') {
        const container = document.getElementById('notifications');
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        
        const icons = {
            success: '✅',
            error: '❌',
            info: 'ℹ️'
        };
        
        notification.innerHTML = `
            <span>${icons[type]}</span>
            <span>${message}</span>
        `;
        
        container.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }
}

// Añadir estilos adicionales
const additionalStyles = `
.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 15px;
    margin-bottom: 20px;
}

.info-item {
    background: var(--bg);
    padding: 15px;
    border-radius: 8px;
    border-left: 4px solid var(--primary);
}

.info-label {
    font-weight: 600;
    color: var(--text-light);
    font-size: 14px;
    margin-bottom: 5px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
`;

// Agregar estilos adicionales
const styleElement = document.createElement('style');
styleElement.textContent = additionalStyles;
document.head.appendChild(styleElement);

// Iniciar la aplicación
const app = new BitacoraApp();
//</script>
