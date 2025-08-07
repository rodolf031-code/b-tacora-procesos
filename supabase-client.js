```javascript
// IMPORTANTE: Reemplaza estos valores con los tuyos de Supabase
const SUPABASE_URL = 'TU_SUPABASE_URL_AQUI'; // https://xxxxx.supabase.co
const SUPABASE_ANON_KEY = 'TU_SUPABASE_ANON_KEY_AQUI'; // eyJ...

// Crear cliente de Supabase
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Clase para manejar la base de datos
class Database {
    // Obtener todas las reuniones
    async getMeetings() {
        try {
            const { data, error } = await supabase
                .from('meetings')
                .select(`
                    *,
                    participants (name),
                    conclusions (conclusion, order_index)
                `)
                .order('created_at', { ascending: false });

            if (error) throw error;
            return data || [];
        } catch (error) {
            console.error('Error al obtener reuniones:', error);
            throw error;
        }
    }

    // Crear nueva reunión
    async createMeeting(meetingData) {
        try {
            // Primero crear la reunión
            const { data: meeting, error: meetingError } = await supabase
                .from('meetings')
                .insert({
                    title: meetingData.title,
                    date: meetingData.date,
                    department: meetingData.department,
                    objective: meetingData.objective,
                    raw_content: meetingData.rawContent,
                    process_count: meetingData.processCount || 0,
                    system_count: meetingData.systemCount || 0,
                    finding_count: meetingData.findingCount || 0
                })
                .select()
                .single();

            if (meetingError) throw meetingError;

            // Crear participantes si existen
            if (meetingData.participants && meetingData.participants.length > 0) {
                const participantsData = meetingData.participants.map(name => ({
                    meeting_id: meeting.id,
                    name: name
                }));

                const { error: participantsError } = await supabase
                    .from('participants')
                    .insert(participantsData);

                if (participantsError) throw participantsError;
            }

            // Crear conclusiones si existen
            if (meetingData.conclusions && meetingData.conclusions.length > 0) {
                const conclusionsData = meetingData.conclusions.map((conclusion, index) => ({
                    meeting_id: meeting.id,
                    conclusion: conclusion,
                    order_index: index
                }));

                const { error: conclusionsError } = await supabase
                    .from('conclusions')
                    .insert(conclusionsData);

                if (conclusionsError) throw conclusionsError;
            }

            return meeting;
        } catch (error) {
            console.error('Error al crear reunión:', error);
            throw error;
        }
    }

    // Eliminar reunión
    async deleteMeeting(meetingId) {
        try {
            const { error } = await supabase
                .from('meetings')
                .delete()
                .eq('id', meetingId);

            if (error) throw error;
        } catch (error) {
            console.error('Error al eliminar reunión:', error);
            throw error;
        }
    }

    // Obtener departamentos únicos
    async getDepartments() {
        try {
            const { data, error } = await supabase
                .from('meetings')
                .select('department')
                .not('department', 'is', null)
                .order('department');

            if (error) throw error;

            // Obtener valores únicos
            const departments = [...new Set(data.map(m => m.department))].filter(d => d);
            return departments;
        } catch (error) {
            console.error('Error al obtener departamentos:', error);
            throw error;
        }
    }

    // Obtener estadísticas
    async getStats() {
        try {
            const { data, error } = await supabase
                .from('meetings')
                .select('process_count, system_count, finding_count');

            if (error) throw error;

            const stats = {
                totalMeetings: data.length,
                totalProcesses: data.reduce((sum, m) => sum + (m.process_count || 0), 0),
                totalSystems: data.reduce((sum, m) => sum + (m.system_count || 0), 0),
                totalFindings: data.reduce((sum, m) => sum + (m.finding_count || 0), 0)
            };

            return stats;
        } catch (error) {
            console.error('Error al obtener estadísticas:', error);
            throw error;
        }
    }
}

// Exportar instancia de la base de datos
window.db = new Database();
```
