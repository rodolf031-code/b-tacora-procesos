// IMPORTANTE: Reemplaza estos valores c
// IMPORTANTE: Reemplaza estos valores c
on los tuy
on los tuy
os de Supaba
os de Supaba
se
se
SUPABASE_U
const SUPABASE_U
const
R
R
L
L
'TU_SUPABASE_U
= = 'TU_SUPABASE_U
R
R
// https://xxxxx.supaba
L_AQUI';;// https://xxxxx.supaba
L_AQUI'
se.c
se.c
o
o
const SUPABASE_ANON_KEY
const
SUPABASE_ANON_KEY= = 'TU_SUPABASE_ANON_KEY_AQUI'
// eyJ...
'TU_SUPABASE_ANON_KEY_AQUI';;// eyJ...
// Crear cliente de Supaba
// Crear cliente de Supaba
se
se
const supabase
const
supabase = =
window
window..supabase
supabase..createClient
SUPABASE_U
createClient((SUPABASE_U
// Cla
// Cla
se para manej
se para manej
ar la ba
ar la ba
se de da
se de da
tos
tos
class Database
class
Database {{
// Obtener toda
// Obtener toda
s la
s la
s reuniones
s reuniones
async getMeetings
async
getMeetings(()){{
try {{
try
const {{ data
const
data,, error
error }}= = await
supabase
await supabase
..from
'meetings'))
from(('meetings'
..select
select((` `
*, *,
participants (name),
participants (name),
conclusions (conclusion, order_index)
conclusions (conclusion, order_index)
` `))
..order
order(('created_at'
'created_at',,{{ascending
ascending::
false }}));;
false
R
R
SUPABASE_ANON_KEY));;
L,,SUPABASE_ANON_KEY
L
if if ((error
error))throw
throw error
error;;
return
return data
data |||| [[]];;
}}catch
catch ((error
error)){{
console..error
console
error(('Error al obtener reuniones:'
'Error al obtener reuniones:',, error
error));;
throw error
throw
error;;
}}
}}
// Crear nueva reunión
// Crear nueva reunión
async createMeeting
async
createMeeting((meetingData
meetingData)){{
try {{
try
// Primero
// Primero
crear la reunión
crear la reunión
const {{data
const
data:: meeting
meeting,,error
error:: meetingError
meetingError }}= = await
supabase
await supabase
..from
'meetings'))
from(('meetings'
..insert
insert(({{
title
title:: meetingData
meetingData..title
title,,
date:: meetingData
date
meetingData..date
date,,
department:: meetingData
department
meetingData..department
department,,
objective
objective:: meetingData
meetingData..objective
objective,,
raw_content:: meetingData
raw_content
meetingData..rawContent
rawContent,,
process_count:: meetingData
process_count
meetingData..processCount
processCount |||| 0 0,,
system_count:: meetingData
system_count
meetingData..systemCount
systemCount |||| 0 0,,
finding_count:: meetingData
finding_count
meetingData..findingCount
findingCount |||| 0 0
}}))
..select
select(())
..single
single(());;
if if ((meetingError
meetingError))throw
meetingError;;
throw meetingError
// Crear participantes si existen
// Crear participantes si existen
if if ((meetingData
meetingData..participants
participants && && meetingData
meetingData..participants
participants..length
length> > 0 0)){{
const participantsData
const
participantsData = =
meetingData..participants
meetingData
participants..map
map((name
=
name=
> (({{
>
meeting_id:: meeting
meeting_id
meeting..id id,,
name
name:: name
name
}}))));;
const {{error
const
error:: participantsError
participantsError }}= = await
supabase
await supabase
..from
'participants'))
from(('participants'
..insert
insert((participantsData
participantsData));;
if if ((participantsError
participantsError))throw
participantsError;;
throw participantsError
}}
// Crear c
// Crear c
onclusiones si existen
onclusiones si existen
if if ((meetingData
meetingData..conclusions
conclusions && && meetingData
meetingData..conclusions
conclusions..length
length> > 0 0)){{
const conclusionsData
const
conclusionsData = =
meetingData..conclusions
meetingData
conclusions..map
map((((conclusion
conclusion,, index
=
index))=
> (({{
>
meeting_id:: meeting
meeting_id
meeting..id id,,
conclusion:: conclusion
conclusion
conclusion,,
index
order_index:: index
order_index
}}))));;
const {{error
const
error:: conclusionsError
conclusionsError }}= = await
supabase
await supabase
..from
'conclusions'))
from(('conclusions'
..insert
insert((conclusionsData
conclusionsData));;
if if ((conclusionsError
conclusionsError))throw
conclusionsError;;
throw conclusionsError
}}
return meeting
return
meeting;;
}}catch
catch ((error
error)){{
console..error
console
error(('Error al crear reunión:'
'Error al crear reunión:',, error
error));;
throw error
throw
error;;
}}
}}
// Eliminar reunión// Eliminar reunión
async deleteMeeting
async
deleteMeeting((meetingId
meetingId)){{
try {{
try
const {{ error
const
error }}= = await
supabase
await supabase
..from
'meetings'))
from(('meetings'
..delete
delete(())
..eq eq(('id'
'id',, meetingId
meetingId));;
if if ((error
error))throw
throw error
error;;
}}catch
catch ((error
error)){{
console..error
console
error(('Error al eliminar reunión:'
'Error al eliminar reunión:',, error
error));;
throw error
throw
error;;
}}
}}
// Obtener departamentos únic
// Obtener departamentos únic
os
os
async getDepartments
async
getDepartments(()){{
try {{
try
const {{ data
const
data,, error
error }}= = await
supabase
await supabase
..from
'meetings'))
from(('meetings'
..select
'department'))
select(('department'
..not
not(('department'
'department',,'is'
'is',,null
null))
..order
'department'));;
order(('department'
if if ((error
error))throw
throw error
error;;
// Obtener valores únic
// Obtener valores únic
os
os
const departments
const
departments = = [[...
...new
new Set
Set((data
data..map
=
map((m m =
> m m..department
>
department))))]]..filter
=
filter((d d =
> d d));;
>
return
return departments
departments;;
}}catch
catch ((error
error)){{
console..error
console
error(('Error al obtener departamentos:'
'Error al obtener departamentos:',, error
error));;
throw error
throw
error;;
}}
}}
// Obtener estadístic
// Obtener estadístic
a
a
s
s
async getStats
async
getStats(()){{
try {{
try
const {{ data
const
data,, error
error }}= = await
supabase
await supabase
..from
'meetings'))
from(('meetings'
..select
'process_count, system_count, finding_count'));;
select(('process_count, system_count, finding_count'
if if ((error
error))throw
throw error
error;;
const stats
const
stats = = {{
totalMeetings:: data
totalMeetings
data..length
length,,
totalProcesses:: data
totalProcesses
data..reduce
reduce((((sum
=
sum,, m m))=
>
> sum
sum + + ((m m..process_count
process_count |||| 0 0)),,0 0)),,
totalSystems:: data
totalSystems
data..reduce
reduce((((sum
=
sum,, m m))=
>
> sum
sum + + ((m m..system_count
system_count |||| 0 0)),,0 0)),,
totalFindings:: data
totalFindings
data..reduce
reduce((((sum
=
sum,, m m))=
>
> sum
sum + + ((m m..finding_count
finding_count |||| 0 0)),,0 0))
}};;
return
return stats
stats;;
}}catch
catch ((error
error)){{
console..error
console
error(('Error al obtener estadísticas:'
'Error al obtener estadísticas:',, error
error));;
throw error
throw
error;;
}}
}}
}}
// Exportar instancia de la ba
// Exportar instancia de la ba
se de da
se de da
tos
tos
window..db db = = new
window
new Database
