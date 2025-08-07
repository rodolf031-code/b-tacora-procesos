// Cla
// Cla
se principal de la aplic
se principal de la aplic
class BitacoraApp
class
BitacoraApp {{
constructor(()){{
constructor
this..meetings
this
meetings= = [[]];;
this..departments
this
departments= = [[]];;
this..init
this
init(());;
a
a
ción
ción
}}
async init
async
init(()){{
show
this..show
this
Loader((true
Loader
true));;
this..setupEventListeners
this
setupEventListeners(());;
await this
await
this..loadMeetings
loadMeetings(());;
await this
await
this..updateDepartmentFilter
updateDepartmentFilter(());;
show
this..show
this
Loader((false
Loader
false));;
}}
show
show
Loader((show
Loader
show)){{
const loader
const
loader = = document
document..getElementById
'loader'));;
getElementById(('loader'
if if ((show
show)){{
loader..classList
loader
classList..remove
'hidden'));;
remove(('hidden'
}}else
else {{
loader..classList
loader
classList..add
'hidden'));;
add(('hidden'
}}
}}
setupEventListeners(()){{
setupEventListeners
const uploadArea uploadArea = = document
const
document..getElementById
'uploadArea'));;
getElementById(('uploadArea'
const fileInput
const
fileInput = = document
document..getElementById
'fileInput'));;
getElementById(('fileInput'
// Drag and drop
// Drag and drop
uploadArea uploadArea..addEventListener
addEventListener(('dragover'
=
'dragover',,((e e))=
> {{
>
e e..preventDefault
preventDefault(());;
uploadArea uploadArea..classList
classList..add
add(('dragover'
'dragover'));;
}}));;
uploadArea uploadArea..addEventListener
addEventListener(('dragleave'
=
'dragleave',,(())=
> {{
>
uploadArea uploadArea..classList
classList..remove
'dragover'));;
remove(('dragover'
}}));;
uploadArea uploadArea..addEventListener
addEventListener(('drop'
=
'drop',,((e e))=
> {{
>
e e..preventDefault
preventDefault(());;
uploadArea uploadArea..classList
classList..remove
'dragover'));;
remove(('dragover'
const files files = = e e..dataTransfer
const
dataTransfer..filesfiles;;
if if ((filesfiles..length
length> > 0 0)){{
this..handleFile
this
handleFile((filesfiles[[0 0]]));;
}}
}}));;
uploadArea uploadArea..addEventListener
addEventListener(('click'
=
'click',,(())=
> {{
>
fileInput..click
fileInput
click(());;
}}));;
fileInput..addEventListener
fileInput
addEventListener(('change'
=
'change',,((e e))=
> {{
>
if if ((e e..target
target..filesfiles..length
length> > 0 0)){{
this..handleFile
this
handleFile((e e..target
target..filesfiles[[0 0]]));;
}}
}}));;
// Filtros
// Filtros
document..getElementById
document
getElementById(('searchInput'
'searchInput'))..addEventListener
addEventListener(('input'
=
'input',,(())=
> this
>
this..filterMeetingsfilterMeetings(())));;
document..getElementById
document
getElementById(('departmentFilter'
'departmentFilter'))..addEventListener
addEventListener(('change'
=
'change',,(())=
> this
>
this..filterMeetingsfilterMeetings(())));;
document..getElementById
document
getElementById(('dateFilter'
'dateFilter'))..addEventListener
addEventListener(('change'
=
'change',,(())=
> this
>
this..filterMeetingsfilterMeetings(())));;
// Cerrar modal al h
// Cerrar modal al h
a
a
cer clic fuera
cer clic fuera
window..onclick
window
onclick= = ((event
=
event))=
> {{
>
const modal
const
modal = = document
document..getElementById
'meetingModal'));;
getElementById(('meetingModal'
if if ((event
event..target
===
target===
modal)){{
modal
this..closeModal
this
closeModal(());;
}}
}};;
}}
async handleFile
async
handleFile((file
file)){{
const reader
const
reader = = new
new FileReader
FileReader(());;
reader..onload
reader
onload = = async
=
async ((e e))=
> {{
>
const content
const
content = = e e..target
target..result
result;;
const meeting
const
meeting = = this
this..parseTranscript
parseTranscript((content
content));;
if if ((meeting
meeting)){{
try {{
try
this..showNotification
this
showNotification(('Subiendo reunión...'
'Subiendo reunión...',,'info'
'info'));;
// Guardar en Supaba
// Guardar en Supaba
se
se
awaitwindow
await
window..db db..createMeeting
createMeeting((meeting
meeting));;
// Rec
// Rec
argar reuniones
argar reuniones
await this
await
this..loadMeetings
loadMeetings(());;
await this
await
this..updateDepartmentFilter
updateDepartmentFilter(());;
this..showNotification
this
showNotification(('¡Reunión agregada exitosamente!'
'success'));;
'¡Reunión agregada exitosamente!',,'success'
// Limpiar el input
// Limpiar el input
document..getElementById
document
getElementById(('fileInput'
'fileInput'))..
valuevalue= = '''';;
}}catch
catch ((error
error)){{
this..showNotification
this
showNotification(('Error al guardar la reunión'
'error'));;
'Error al guardar la reunión',,'error'
console..error
console
error((error
error));;
}}
}}
}};;
reader..readAsText
reader
readAsText((file
file));;
}}
parseTranscript((content
parseTranscript
content)){{
const meeting
const
meeting = = {{
content
rawContent:: content
rawContent
}};;
// Extraer título
// Extraer título
const titleMatch
const
titleMatch = = content
content..match
match((//# ANÁLISIS DE TRANSCRIPCIÓN[^-]*-\s*(.+)
# ANÁLISIS DE TRANSCRIPCIÓN[^-]*-\s*(.+)//i i));;
if if ((titleMatch
titleMatch)){{
meeting..title
meeting
title= = titleMatch
titleMatch[[11]]
..replace
replace((//LEVANTAMIENTO DE PR
OCESOS LIPU\s*-\s*LEVANTAMIENTO DE PR
OCESOS LIPU\s*-\s*//i i,,''''))
..trim
trim(());;
}}
// Extraer inf
// Extraer inf
orma
orma
ción del resumen ejecutivo
ción del resumen ejecutivo
const executiveSummaryMatch
const
executiveSummaryMatch = = content
content..match
match((//##\s*1\.\s*RESU
##\s*1\.\s*RESU
if if ((executiveSummaryMatch
executiveSummaryMatch)){{
const summaryContent
const
summaryContent = = executiveSummaryMatch
executiveSummaryMatch[[11]];;
MEN EJECUTIVO([\s\S]*?)(?=---|\n##\s*2\.
MEN EJECUTIVO([\s\S]*?)(?=---|\n##\s*2\.
// Fech
// Fech
a
a
const dateMatch
const
dateMatch = = summaryContent
summaryContent..match
match((//(?:Fecha y hora)[:\s]*([^\n]+)
(?:Fecha y hora)[:\s]*([^\n]+)//i i));;
if if ((dateMatch
dateMatch)){{
meeting
meeting..date
date= = dateMatch
dateMatch[[11]]..trim
trim(());;
}}
// Participantes
// Participantes
const participantsMatch
const
participantsMatch = = summaryContent
summaryContent..match
match((//\*\*Participantes:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)
\*\*Participantes:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)//i i));;
if if ((participantsMatch
participantsMatch)){{
meeting
meeting..participants
participants= = participantsMatch
participantsMatch[[11]]
..split
split(('\n'
'\n'))
..filter
filter((line
=
line=
> line
>
line..trim
trim(())..startsWith
startsWith(('-'
'-'))))
..map
map((line
=
line=
> line
>
line..replace
replace((//^-\s*
^-\s*//,,''''))..trim
trim(())))
..filter
=
filter((p p =
> p p..length
>
length> > 0 0));;
}}
// Departamento
// Departamento
const deptMatch
const
deptMatch = = summaryContent
summaryContent..match
\*\*Área o departamento analizado:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)
match((//\*\*Área o departamento analizado:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)
if if ((deptMatch
deptMatch)){{
const deptLines
const
deptLines = = deptMatch
deptMatch[[11]]
..split
split(('\n'
'\n'))
..filter
filter((line
=
line=
> line
>
line..trim
trim(())..startsWith
startsWith(('-'
'-'))))
..map
map((line
=
line=
> line
>
line..replace
replace((//^-\s*
^-\s*//,,''''))..trim
trim(())))
..filter
=
filter((d d =
> d d..length
>
length> > 0 0));;
if if ((deptLines
deptLines..length
length> > 0 0)){{
meeting
meeting..department
department= = deptLines
deptLines..join
join((', '
', '));;
}}
}}
// Ob
// Ob
jetivo
jetivo
const objMatch
const
objMatch = = summaryContent
summaryContent..match
\*\*O
match((//\*\*O
if if ((objMatch
objMatch)){{
const objLines
const
objLines = = objMatch
objMatch[[11]]
..split
split(('\n'
'\n'))
..filter
filter((line
=
line=
> line
>
line..trim
trim(())..startsWith
startsWith(('-'
'-'))))
..map
map((line
=
line=
> line
>
line..replace
replace((//^-\s*
^-\s*//,,''''))..trim
trim(())))
..filter
=
filter((o o=
> o o..length
>
length> > 0 0));;
bjetivo principal[^:]*:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)//i i));;
bjetivo principal[^:]*:\*\*([\s\S]*?)(?=\*\*[A-Z]|$)
meeting..objective
meeting
objective= = objLines
objLines..join
join((', '
', '));;
}}
// Conclusiones
// Conclusiones
const conclusionsMatch
const
conclusionsMatch = = summaryContent
summaryContent..match
match((//\*\*Conclusiones clave:\*\*([\s\S]*?)$
\*\*Conclusiones clave:\*\*([\s\S]*?)$//i i));;
if if ((conclusionsMatch
conclusionsMatch)){{
meeting
meeting..conclusions
conclusions= = conclusionsMatch
conclusionsMatch[[11]]
..split
split(('\n'
'\n'))
..filter
filter((line
=
line=
>
> //^\d+\.
^\d+\.//..test
test((line
line..trim
trim(())))))
..map
map((line
=
line=
> line
>
line..trim
trim(())));;
}}
}}
// Contar pro
// Contar pro
cesos
cesos
const processTableMatch
const
processTableMatch = = content
content..match
##\s*2\.\s*PR
match((//##\s*2\.\s*PR
OCESOS IDENTIFICADOS([\s\S]*?)(?=---|\n##\s*3\
OCESOS IDENTIFICADOS([\s\S]*?)(?=---|\n##\s*3\
if if ((processTableMatch
processTableMatch)){{
const tableContent
const
tableContent = = processTableMatch
processTableMatch[[11]];;
const rows
const
rows = = tableContent
tableContent..split
split(('\n'
'\n'))..filter
filter((line
=
line=
>
>
line
line..includes
includes(('|'
'|'))&& &&
!!line
line..includes
includes(('Nombre del Proceso'
'Nombre del Proceso'))&& &&
!!line
line..match
match((//^\s*\|?\s*[-]+
^\s*\|?\s*[-]+//))
));;
meeting
meeting..processCount
processCount= = rows
length;;
rows..length
}}
// Contar sistema
// Contar sistema
s
s
const systemsMatch
const
systemsMatch = = content
content..match
##\s*4\.\s*SISTEMAS Y HERRAMIENTAS([\s\S]*?)(?=---|\n##\s*5\.)//i i));;
match((//##\s*4\.\s*SISTEMAS Y HERRAMIENTAS([\s\S]*?)(?=---|\n##\s*5\.)
if if ((systemsMatch
systemsMatch)){{
const systemsContent
const
systemsContent = = systemsMatch
systemsMatch[[11]];;
const rows
const
rows = = systemsContent
systemsContent..split
split(('\n'
'\n'))..filter
filter((line
=
line=
>
>
line
line..includes
includes(('|'
'|'))&& &&
!!line
line..includes
includes(('Sistema'
'Sistema'))&& &&
!!line
line..match
match((//^\s*\|?\s*[-]+
^\s*\|?\s*[-]+//))
));;
meeting
meeting..systemCount
systemCount= = rows
length;;
rows..length
}}
// Contar h
// Contar h
allazgos
allazgos
const findingsMatch
const
findingsMatch = = content
content..match
##\s*6\.\s*HALLAZGOS IMPO
match((//##\s*6\.\s*HALLAZGOS IMPO
if if ((findingsMatch
findingsMatch)){{
const findingsContent
const
findingsContent = =
findingsMatch[[11]];;
findingsMatch
const subsections
const
subsections = =
findingsContent..match
findingsContent
match((//###\s+[^:]+:
###\s+[^:]+://g g))|||| [[]];;
meeting
meeting..findingCount
findingCount= = subsections
subsections..length
length;;
RTANTES([\s\S]*?)(?=---|\n##\s*7\.)//i i));;
RTANTES([\s\S]*?)(?=---|\n##\s*7\.)
}}
return meeting
return
meeting;;
}}
async loadMeetings
async
loadMeetings(()){{
try {{
try
this..meetings
this
meetings= = await
awaitwindow
window..db db..getMeetings
getMeetings(());;
this..renderTimeline
this
renderTimeline(());;
await this
await
this..updateStats
updateStats(());;
}}catch
catch ((error
error)){{
this..showNotification
this
showNotification(('Error al cargar reuniones'
'error'));;
'Error al cargar reuniones',,'error'
console..error
console
error((error
error));;
}}
}}
renderTimeline(()){{renderTimeline
const timeline
const
timeline = = document
document..getElementById
'timeline'));;
getElementById(('timeline'
const filteredMeetings filteredMeetings = = this
const
this..getFilteredMeetings
getFilteredMeetings(());;
if if ((filteredMeetingsfilteredMeetings..length
length===
=== 0 0)){{
innerHTM
timeline..innerHTM
timeline
L
L
= = ` `
< <div
div class
class= =""empty-state
empty-state""> >
< <div
div class
class= =""empty-state-icon
div
empty-state-icon""> >📭 📭</ </div
> >
< <h3 h3> >No hay reuniones
No hay reuniones</ </h3 h3> >
< <p p> >Carga tu primera reunión para comenzar
Carga tu primera reunión para comenzar</ </p p> >
div
</ </div
> >
` `;;
return;;
return
}}
innerHTM
timeline..innerHTM
timeline
L
L
= = '''';;
filteredMeetings filteredMeetings..forEach
forEach((((meeting
meeting,, index
=
index))=
> {{
>
const item
const
item = = document
document..createElement
createElement(('div'
'div'));;
item
item..className
'timeline-item';;
className= = 'timeline-item'
item
item..style
style..animationDelay
animationDelay = = ` `${ ${index
index ** 0.1
0.1}}s s` `;;
const dot
const
dot = = document
document..createElement
createElement(('div'
'div'));;
dot
dot..className
'timeline-dot';;
className= = 'timeline-dot'
const content
const
content = = document
document..createElement
createElement(('div'
'div'));;
content
content..className
'timeline-content';;
className= = 'timeline-content'
// Contar participantes
// Contar participantes
const participantCount
const
participantCount = =
meeting
meeting..participants
participants ?? meeting
meeting..participants
participants..length
length :: 0 0;;
innerHTM
content..innerHTM
content
L
L
= = ` `
< <button
button class
class= =""delete-btn
delete-btn""onclick
onclick= =""app
app..deleteMeeting
deleteMeeting((${ ${meeting
meeting..id id}},, event
event))""title
title= =""Eliminar reunión
Eliminar reunión""> >
🗑 🗑
</ </button
button> >
< <div
div class
class= =""meeting-header
meeting-header""onclick
onclick= =""app
show
app..show
MeetingDetails((${ ${meeting
MeetingDetails
meeting..id id}}))""> >
div
< <div
> >
< <div
div class
class= =""meeting-title
meeting-title""> >${ ${meeting
meeting..title
title |||| meeting
meeting..department
department ||||'Sin título'
div
'Sin título'}}</ </div
> >
< <div
div class
class= =""meeting-date
meeting-date""> >${ ${meeting
meeting..date
date ||||'Sin fecha'
div
'Sin fecha'}}</ </div
> >
div
</ </div
> >
div
</ </div
> >
< <div
div class
class= =""meeting-objective
meeting-objective""onclick
onclick= =""app
show
app..show
MeetingDetails((${ ${meeting
MeetingDetails
meeting..id id}}))""> >
${ ${meeting
meeting..objective
'Sin objetivo definido'}}
objective ||||'Sin objetivo definido'
div
</ </div
> >
< <div
div class
class= =""meeting-stats
meeting-stats""> >
< <div
div class
class= =""stat
stat""> >
< <div
div class
class= =""stat-icon
div
stat-icon""> >👥 👥 </ </div
> >
< <span
span> >${ ${participantCount
participantCount}} participantes
participantes</ </span
span> >
div
</ </div
> >
< <div
div class
class= =""stat
stat""> >
< <div
div class
class= =""stat-icon
stat-icon""> >
⚙ ⚙
div
</ </div
> >
< <span
span> >${ ${meeting
meeting..process_count
process_count ||||0 0}} procesos
procesos</ </span
span> >
div
</ </div
> >
< <div
div class
class= =""stat
stat""> >
< <div
div class
class= =""stat-icon
div
stat-icon""> >💻 💻</ </div
> >
< <span
span> >${ ${meeting
meeting..system_count
system_count ||||0 0}} sistemas
sistemas</ </span
span> >
div
</ </div
> >
div
</ </div
> >
` `;;
item
item..appendChild
appendChild((dot
dot));;
item
item..appendChild
appendChild((content
content));;
timeline
timeline..appendChild
appendChild((item
item));;
}}));;
}}
async deleteMeeting
async
deleteMeeting((meetingId
meetingId,, event
event)){{
event
event..stopPropagation
stopPropagation(());;
if if ((confirm
'¿Estás seguro de que quieres eliminar esta reunión?')))){{
confirm(('¿Estás seguro de que quieres eliminar esta reunión?'
try {{
try
awaitwindow
await
window..db db..deleteMeeting
deleteMeeting((meetingId
meetingId));;
await this
await
this..loadMeetings
loadMeetings(());;
await this
await
this..updateDepartmentFilter
updateDepartmentFilter(());;
this..showNotification
this
showNotification(('Reunión eliminada'
'success'));;
'Reunión eliminada',,'success'
}}catch
catch ((error
error)){{
this..showNotification
this
showNotification(('Error al eliminar la reunión'
'error'));;
'Error al eliminar la reunión',,'error'
console..error
console
error((error
error));;
}}
}}
}}
show
show
MeetingDetails((meetingId
MeetingDetails
meetingId)){{
const meeting
const
meeting = = this
this..meetings
meetings..find
=
find((m m =
===
> m m..id id ===
>
if if ((!!meeting
meeting))return
return;;
meetingId));;
meetingId
const modal
const
modal = = document
document..getElementById
'meetingModal'));;
getElementById(('meetingModal'
const modalTitle
const
modalTitle = = document
document..getElementById
'modalTitle'));;
getElementById(('modalTitle'
const modalBody
const
modalBody = = document
document..getElementById
getElementById(('modalBody'
'modalBody'));;
innerHTM
modalTitle..innerHTM
modalTitle
L
L
= = ` `
< <span
span style
style= =""font-size
font-size::28 28px px;;margin-right
margin-right::10 10px px;;""> >📋 📋</ </span
span> >
${ ${meeting
meeting..title
title |||| meeting
meeting..department
'Reunión de Análisis'}}
department ||||'Reunión de Análisis'
` `;;
// Aquí puedes agregar el código para mostrar el c
// Aquí puedes agregar el código para mostrar el c
ontenido
ontenido
c
c
ompleto
ompleto
// Por a
// Por a
h
h
ora mostramos un resumen simple
ora mostramos un resumen simple
innerHTM
modalBody..innerHTM
modalBody
L
L
= = ` `
< <div
div class
class= =""section
section""> >
< <h3 h3class
class= =""section-title
section-title""> >
< <span
span class
class= =""section-icon
section-icon""> >📊 📊</ </span
span> >
Resumen Ejecutivo Resumen Ejecutivo
</ </h3 h3> >
< <div
div class
class= =""info-grid
info-grid""> >
< <div
div class
class= =""info-item
info-item""> >
< <div
div class
class= =""info-label
info-label""> >Fecha
div
Fecha</ </div
> >
div
< <div
> >${ ${meeting
meeting..date
date ||||'No especificada'
div
'No especificada'}}</ </div
> >
div
</ </div
> >
< <div
div class
class= =""info-item
info-item""> >
< <div
div class
class= =""info-label
info-label""> >Departamento
div
Departamento</ </div
> >
div
< <div
> >${ ${meeting
meeting..department
department ||||'No especificado'
div
'No especificado'}}</ </div
> >
div
</ </div
> >
< <div
div class
class= =""info-item
info-item""> >
< <div
div class
class= =""info-label
info-label""> >
O
O
bjetivo
div
bjetivo</ </div
> >
div
< <div
> >${ ${meeting
meeting..objective
objective ||||'No especificado'
div
'No especificado'}}</ </div
> >
div
</ </div
> >
div
</ </div
> >
${ ${meeting
meeting..participants
participants && && meeting
meeting..participants
participants..length
length> >0 0??` `
<div class="info-item" style="margin-top: 20px;">
<div class="info-item" style="margin-top: 20px;">
<div class="info-label">Participantes</div
<div class="info-label">Participantes</div
>
>
<ul>
<ul>
${ ${meeting
meeting..participants
participants..map
=
map((p p =
>` `<li>
>
<li>${ ${p p..name
name}}</li>
</li>` `))..join
join((''''))}}
</ul>
</ul>
</div
</div
>
>
` ` ::''''}}
${ ${meeting
meeting..conclusions
conclusions && && meeting
meeting..conclusions
conclusions..length
length> >0 0??` `
<div class="info-item" style="margin-top: 20px;">
<div class="info-item" style="margin-top: 20px;">
<div class="info-label">Conclusiones</div
<div class="info-label">Conclusiones</div
>
>
<ol>
<ol>
${ ${meeting
conclusions
meeting..conclusions
..sort
=
sort((((a a,, b b))=
> a a..order_index
>
order_index -- b b..order_index
order_index))
..map
=
map((c c=
>` `<li>
>
<li>${ ${c c..conclusion
conclusion..replace
replace((//^\d+\.\s*
^\d+\.\s*//,,''''))}}</li>
</li>` `))
..join
join((''''))}}
</ol>
</ol>
</div
</div
>
>
` ` ::''''}}
div
</ </div
> >
< <div
div class
class= =""section
section""> >
< <h3 h3class
class= =""section-title
section-title""> >
< <span
span class
class= =""section-icon
section-icon""> >📄 📄</ </span
span> >
Contenido Completo
Contenido Completo
</ </h3 h3> >
< <div
div style
style= =""white-spacewhite-space:: pre-wrap
pre-wrap;;
font-family:: monospace
font-family
monospace;;background
background::#f5f5f5
#f5f5f5;;padding
padding::20 20px px;;bordeborde
${ ${this
this..escapeHtml
escapeHtml((meeting
meeting..raw_content
raw_content))}}
div
</ </div
> >
div
</ </div
> >
` `;;
modal..style
modal
style..display
'block';;
display = = 'block'
}}
escapeHtml((text
escapeHtml
text)){{
div
const div
const
= = document
document..createElement
createElement(('div'
'div'));;
div..textContent
div
textContent= = text
text;;
return div
return
innerHTM
div..innerHTM
L;;
L
filterMeetingsfilterMeetings(()){{
this..renderTimeline
this
renderTimeline(());;
}}
}}
}}
closeModal(()){{
closeModal
document..getElementById
document
getElementById(('meetingModal'
'meetingModal'))..style
style..display
'none';;
display = = 'none'
getFilteredMeetings(()){{
getFilteredMeetings
const search
const
search = = document
document..getElementById
getElementById(('searchInput'
'searchInput'))..
valuevalue..toLowerCase
toLowerCase(());;
const department
const
department = = document
document..getElementById
'departmentFilter'))..
getElementById(('departmentFilter'
valuevalue;;
const date
const
date = = document
document..getElementById
getElementById(('dateFilter'
'dateFilter'))..
valuevalue;;
return
return this
this..meetings
meetings..filter
filter((meeting
=
meeting=
> {{
>
const matchSearch
const
matchSearch = = !!search
search ||||
meeting
meeting..raw_content
raw_content..toLowerCase
toLowerCase(())..includes
includes((search
search))||||
((meeting
meeting..department
department && && meeting
meeting..department
department..toLowerCase
toLowerCase(())..includes
includes((search
search))))||||
((meeting
meeting..title
title && && meeting
meeting..title
title..toLowerCase
toLowerCase(())..includes
includes((search
search))));;
const matchDepartment
const
matchDepartment = = !!department
department |||| meeting
meeting..department
department===
department;;
=== department
const matchDate
const
matchDate = = !!date
date |||| ((meeting
meeting..date
date && && meeting
meeting..date
date..includes
includes((date
date))));;
return
return matchSearch
matchSearch && && matchDepartment
matchDepartment && && matchDate
matchDate;;
}}));;
}}
async updateStats
async
updateStats(()){{
try {{
try
const stats
const
stats = = await
awaitwindow
window..db db..getStats
getStats(());;
document..getElementById
document
getElementById(('totalMeetings'
'totalMeetings'))..textContent
textContent= = stats
totalMeetings;;
stats..totalMeetings
document..getElementById
document
getElementById(('totalProcesses'
'totalProcesses'))..textContent
textContent= = stats
totalProcesses;;
stats..totalProcesses
document..getElementById
document
getElementById(('totalSystems'
'totalSystems'))..textContent
textContent= = stats
totalSystems;;
stats..totalSystems
document..getElementById
document
getElementById(('totalFindings'
'totalFindings'))..textContent
textContent= = stats
totalFindings;;
stats..totalFindings
}}catch
catch ((error
error)){{
console..error
console
error(('Error al actualizar estadísticas:'
'Error al actualizar estadísticas:',, error
error));;
}}
}}
async updateDepartmentFilter
async
updateDepartmentFilter(()){{
try {{
try
const departments
const
departments = = await
awaitwindow
window..db db..getDepartments
getDepartments(());;
const select
const
select = = document
document..getElementById
'departmentFilter'));;
getElementById(('departmentFilter'
innerHTM
select..innerHTM
select
L
L
'<option value="">Todos los departamentos</option>';;
= = '<option value="">Todos los departamentos</option>'
departments..forEach
departments
forEach((dept
=
dept=
> {{
>
const option
const
option = = document
document..createElement
createElement(('option'
'option'));;
option..
option
valuevalue= = dept
dept;;
option..textContent
option
textContent= = dept
dept;;
select..appendChild
select
appendChild((option
option));;
}}));;
}}catch
catch ((error
error)){{
console..error
console
error(('Error al actualizar filtro de departamentos:'
'Error al actualizar filtro de departamentos:',, error
error));;
}}
}}
showNotification((message
showNotification
message,, type
type = = 'info'
'info')){{
const container
const
container = = document
document..getElementById
'notifications'));;
getElementById(('notifications'
const notification
const
notification = = document
document..createElement
createElement(('div'
'div'));;
notification..className
notification
className= = ` `notification
notification ${ ${type
type}}` `;;
const icons
const
icons = = {{
success:: '✅ '
success
'✅ ',,
error:: '❌ '
error
'❌ ',,
info:: 'ℹ '
info
'ℹ '
}};;
innerHTM
notification..innerHTM
notification
L
L
= = ` `
< <span
span> >${ ${icons
icons[[type
type]]}}</ </span
span> >
< <span
span> >${ ${message
message}}</ </span
span> >
` `;;
container..appendChild
container
appendChild((notification
notification));;
=
setTimeout(((())=
setTimeout
> {{
>
notification..remove
notification
remove(());;
}},,3000
3000));;
}}
}}
// Añadir estilos adicionales
// Añadir estilos adicionales
const additionalStyles
const
additionalStyles = = ` `
.info-grid {
.info-grid {
display: grid;
display: grid;
grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
gap: 15px;
gap: 15px;
margin-bottom: 20px;
margin-bottom: 20px;
}}
.info-item {
.info-item {
background:
background:
var(--bg);
var(--bg);
padding: 15px;
padding: 15px;
border-radius: 8px;
border-radius: 8px;
border-left: 4px solid var(--primary);
border-left: 4px solid var(--primary);
}}
.info-label {
.info-label {
font-weight: 600;
font-weight: 600;
color:
color:
var(--text-light);
var(--text-light);
font-size: 14px;
font-size: 14px;
margin-bottom: 5px;
margin-bottom: 5px;
text-transform: uppercase;
text-transform: uppercase;
letter-spacing: 0.5px;
letter-spacing: 0.5px;
}}
` `;;
// Agregar estilos adicionales
// Agregar estilos adicionales
const styleElement
const
styleElement = = document
document..createElement
'style'));;
createElement(('style'
styleElement..textContent
styleElement
textContent= = additionalStyles
additionalStyles;;
document
document..head
head..appendChild
appendChild((styleElement
styleElement));;
// Iniciar la aplic
// Iniciar la aplic
a
a
ción
ción
const app
const
app = = new
new BitacoraApp
BitacoraApp(());;
< <//script
script> >
