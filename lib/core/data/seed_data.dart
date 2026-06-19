import '../../models/dev_tip.dart';
import '../../models/cheat_sheet.dart';
import '../services/hive_service.dart';

class SeedData {
  // Liste locale de tips dev utilisée en fallback offline
  static const List<DevTip> localDevTips = [
    DevTip(
      content: 'Un bon code se lit comme de la prose.',
      author: 'Robert C. Martin',
      category: 'tip',
    ),
    DevTip(
      content:
          'Le débogage est deux fois plus difficile que l\'écriture du code. Si tu écris le code le plus intelligent possible, tu n\'es, par définition, pas assez intelligent pour le déboguer.',
      author: 'Brian W. Kernighan',
      category: 'tip',
    ),
    DevTip(
      content: 'Premature optimization is the root of all evil.',
      author: 'Donald Knuth',
      category: 'tip',
    ),
    DevTip(
      content: 'Make it work, make it right, make it fast.',
      author: 'Kent Beck',
      category: 'tip',
    ),
    DevTip(
      content: 'Code is like humor. When you have to explain it, it\'s bad.',
      author: 'Cory House',
      category: 'tip',
    ),
    DevTip(
      content: 'First, solve the problem. Then, write the code.',
      author: 'John Johnson',
      category: 'tip',
    ),
    DevTip(
      content:
          'Any fool can write code that a computer can understand. Good programmers write code that humans can understand.',
      author: 'Martin Fowler',
      category: 'tip',
    ),
    DevTip(
      content: 'Simplicity is the soul of efficiency.',
      author: 'Austin Freeman',
      category: 'tip',
    ),
  ];

  // Version du seed — à incrémenter pour forcer un re-seed
  static const int _seedVersion = 2;

  // Insère les cheatsheets initiales dans Hive si la box est vide ou obsolète
  static Future<void> seedIfNeeded() async {
    final box = HiveService.ref;
    final settings = HiveService.settings;
    final currentVersion = settings.get('seedVersion', defaultValue: 0) as int;

    if (box.isEmpty || currentVersion < _seedVersion) {
      await box.clear();
      for (final sheet in _initialCheatSheets()) {
        await box.put(sheet.id, sheet.toMap());
      }
      await settings.put('seedVersion', _seedVersion);
    }
  }

  static List<CheatSheet> _initialCheatSheets() => [
        // ─── GIT ───────────────────────────────────────────────────────────
        CheatSheet(
          id: 'git-essentials',
          title: 'Git — Commandes essentielles',
          technology: 'Git',
          tags: ['git', 'vcs', 'terminal'],
          content: '''## Initialisation
```
git init
git clone <url>
```

## Branches
```
git branch              # lister
git branch <nom>        # créer
git checkout <nom>      # changer
git checkout -b <nom>   # créer + changer
git merge <nom>         # fusionner
git branch -d <nom>     # supprimer
```

## Commit
```
git status
git add .
git commit -m "message"
git commit --amend
```

## Remote
```
git remote add origin <url>
git push origin <branche>
git pull origin <branche>
git fetch
```

## Historique & Annuler
```
git log --oneline --graph
git diff HEAD~1
git revert <commit>
git reset --hard <commit>
git stash / git stash pop
```''',
        ),

        CheatSheet(
          id: 'git-advanced',
          title: 'Git — Avancé & Workflows',
          technology: 'Git',
          tags: ['git', 'rebase', 'workflow', 'advanced'],
          content: '''## Rebase
```
git rebase main           # rejouer les commits sur main
git rebase -i HEAD~3      # rebase interactif (squash, edit...)
git rebase --abort        # annuler
git rebase --continue     # continuer après conflit
```

## Cherry-pick
```
git cherry-pick <sha>     # appliquer un commit spécifique
git cherry-pick A..B      # plage de commits
```

## Tags
```
git tag v1.0.0
git tag -a v1.0.0 -m "Release"
git push origin --tags
git tag -d v1.0.0         # supprimer local
```

## Bisect (trouver un bug)
```
git bisect start
git bisect bad            # commit actuel = bugué
git bisect good v1.0      # dernier bon commit
git bisect reset          # fin
```

## Worktree
```
git worktree add ../feature feature-branch
git worktree list
git worktree remove ../feature
```''',
        ),

        // ─── SQL ───────────────────────────────────────────────────────────
        CheatSheet(
          id: 'sql-essentials',
          title: 'SQL — Requêtes fondamentales',
          technology: 'SQL',
          tags: ['sql', 'database', 'requêtes'],
          content: '''## SELECT
```sql
SELECT * FROM table;
SELECT col1, col2 FROM table WHERE condition;
SELECT DISTINCT col FROM table ORDER BY col DESC LIMIT 10;
```

## Filtres
```sql
WHERE col = 'valeur'
WHERE col IN ('a', 'b')
WHERE col BETWEEN 1 AND 10
WHERE col LIKE '%pattern%'
WHERE col IS NULL / IS NOT NULL
```

## Jointures
```sql
INNER JOIN t2 ON t1.id = t2.id
LEFT JOIN  t2 ON t1.id = t2.id
RIGHT JOIN t2 ON t1.id = t2.id
FULL OUTER JOIN t2 ON t1.id = t2.id
```

## Agrégation
```sql
SELECT COUNT(*), AVG(col), SUM(col), MIN(col), MAX(col)
FROM table GROUP BY col HAVING COUNT(*) > 1;
```

## Modifications
```sql
INSERT INTO table (col1, col2) VALUES ('v1', 'v2');
UPDATE table SET col = 'valeur' WHERE condition;
DELETE FROM table WHERE condition;
TRUNCATE TABLE table;
```''',
        ),

        CheatSheet(
          id: 'sql-advanced',
          title: 'SQL — Avancé & Optimisation',
          technology: 'SQL',
          tags: ['sql', 'index', 'window', 'cte', 'advanced'],
          content: '''## CTE (Common Table Expressions)
```sql
WITH active_users AS (
  SELECT * FROM users WHERE active = true
)
SELECT * FROM active_users WHERE age > 18;
```

## Window Functions
```sql
SELECT name, salary,
  RANK() OVER (PARTITION BY dept ORDER BY salary DESC),
  LAG(salary) OVER (ORDER BY hire_date),
  SUM(salary) OVER (PARTITION BY dept)
FROM employees;
```

## Index
```sql
CREATE INDEX idx_name ON table(col);
CREATE UNIQUE INDEX idx_email ON users(email);
DROP INDEX idx_name;
EXPLAIN SELECT * FROM table WHERE col = 'val';
```

## Transactions
```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
ROLLBACK;
```

## Sous-requêtes
```sql
SELECT * FROM orders
WHERE user_id IN (SELECT id FROM users WHERE country = 'FR');
```''',
        ),

        // ─── REGEX ─────────────────────────────────────────────────────────
        CheatSheet(
          id: 'regex-essentials',
          title: 'Regex — Expressions régulières',
          technology: 'Regex',
          tags: ['regex', 'pattern', 'text'],
          content: '''## Caractères
```
.       n'importe quel caractère
\\d      chiffre [0-9]
\\w      mot [a-zA-Z0-9_]
\\s      espace/tab/newline
\\b      limite de mot
```

## Quantificateurs
```
*       0 ou plus
+       1 ou plus
?       0 ou 1
{n,m}   entre n et m fois
```

## Ancres & Groupes
```
^       début de ligne
\$       fin de ligne
(abc)   groupe capturant
(?:abc) groupe non-capturant
[abc]   classe de caractères
[^abc]  classe négative
```

## Exemples courants
```
Email:  ^[\\w.-]+@[\\w.-]+\\.\\w{2,}\$
IP:     \\b(\\d{1,3}\\.){3}\\d{1,3}\\b
Date:   \\d{2}\\/\\d{2}\\/\\d{4}
Tel FR: 0[1-9](\\s?\\d{2}){4}
URL:    https?:\\/\\/[\\w.-]+\\.[a-z]{2,}.*
```''',
        ),

        // ─── TERMINAL ──────────────────────────────────────────────────────
        CheatSheet(
          id: 'terminal-essentials',
          title: 'Terminal / Bash — Commandes courantes',
          technology: 'Terminal',
          tags: ['terminal', 'bash', 'linux', 'cli'],
          content: '''## Navigation
```bash
pwd             # dossier courant
ls -la          # lister fichiers
cd <dossier>    # changer de dossier
cd ..           # remonter
```

## Fichiers
```bash
mkdir <dossier>
touch <fichier>
cp <src> <dest>
mv <src> <dest>
rm <fichier>
rm -rf <dossier>   # ⚠️ irréversible
cat <fichier>
```

## Recherche
```bash
find . -name "*.dart"
grep -r "texte" .
grep -n "texte" file
```

## Processus & Réseau
```bash
ps aux / top
kill <pid>
ping <host>
curl <url>
ssh user@host
```

## Permissions
```bash
chmod 755 <fichier>
chmod +x <script>
sudo <commande>
```''',
        ),

        CheatSheet(
          id: 'bash-scripting',
          title: 'Bash — Scripting',
          technology: 'Terminal',
          tags: ['bash', 'script', 'automation', 'linux'],
          content: '''## Variables & Arguments
```bash
NAME="Alice"
echo "\$NAME"
echo "\$1 \$2"   # arguments du script
echo "\$#"      # nombre d'arguments
echo "\$@"      # tous les arguments
```

## Conditions
```bash
if [ "\$var" == "valeur" ]; then
  echo "oui"
elif [ "\$var" -gt 10 ]; then
  echo "grand"
else
  echo "non"
fi

[ -f file ]    # fichier existe ?
[ -d dir ]     # dossier existe ?
[ -z "\$var" ]  # chaîne vide ?
```

## Boucles
```bash
for i in 1 2 3; do echo "\$i"; done
for f in *.txt; do echo "\$f"; done

while [ \$n -lt 10 ]; do
  ((n++))
done
```

## Fonctions
```bash
function greet() {
  echo "Bonjour \$1"
}
greet "Alice"
```

## Utiles
```bash
set -e          # arrêt si erreur
set -x          # mode debug
trap "cleanup" EXIT
```''',
        ),

        // ─── FLUTTER ───────────────────────────────────────────────────────
        CheatSheet(
          id: 'flutter-essentials',
          title: 'Flutter — Widgets & Layout',
          technology: 'Flutter',
          tags: ['flutter', 'dart', 'mobile', 'widgets'],
          content: '''## Stateless / Stateful
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  @override
  Widget build(BuildContext context) => const Text('Hello');
}
```

## Layout
```dart
Column(crossAxisAlignment: CrossAxisAlignment.start, children: [...])
Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [...])
Stack(children: [...])
Expanded(child: ...)
SizedBox(width: 16, height: 16)
Padding(padding: EdgeInsets.all(16), child: ...)
```

## Widgets courants
```dart
Text('Hello', style: TextStyle(fontSize: 16))
Icon(Icons.home)
Image.network('url')
CircularProgressIndicator()
ElevatedButton(onPressed: () {}, child: Text('OK'))
TextField(controller: TextEditingController())
Switch(value: true, onChanged: (v) {})
```

## Navigation (GoRouter)
```dart
context.go('/route')
context.push('/route')
context.pop()
```''',
        ),

        CheatSheet(
          id: 'flutter-riverpod',
          title: 'Flutter — Riverpod',
          technology: 'Flutter',
          tags: ['flutter', 'riverpod', 'state', 'provider'],
          content: '''## Types de providers
```dart
// Valeur simple
final nameProvider = Provider<String>((ref) => 'Alice');

// Valeur modifiable
final counterProvider = StateProvider<int>((ref) => 0);

// Async (Future)
final dataProvider = FutureProvider<Data>((ref) async {
  return await fetchData();
});

// Classe avec logique
final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>(
  (ref) => TodoNotifier(),
);
```

## StateNotifier
```dart
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  void increment() => state++;
  void reset() => state = 0;
}
```

## ConsumerWidget
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('\$count');
  }
}
```

## Lire / Modifier
```dart
ref.watch(provider)   // rebuild à chaque changement
ref.read(provider)    // lecture one-shot (onPressed)
ref.listen(provider, (prev, next) => {})
ref.invalidate(provider)  // recharger
ref.refresh(provider)     // recharger + retourner valeur
```''',
        ),

        CheatSheet(
          id: 'flutter-animations',
          title: 'Flutter — Animations',
          technology: 'Flutter',
          tags: ['flutter', 'animation', 'transition'],
          content: '''## AnimatedContainer
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: _expanded ? 200 : 100,
  color: _selected ? Colors.blue : Colors.grey,
  child: ...,
)
```

## AnimatedOpacity / AnimatedSwitcher
```dart
AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 200),
  child: ...,
)

AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: Text('\$count', key: ValueKey(count)),
)
```

## TweenAnimationBuilder
```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: 1),
  duration: const Duration(seconds: 1),
  builder: (context, value, child) => Opacity(opacity: value, child: child),
  child: const Text('Hello'),
)
```

## AnimationController
```dart
class _State extends State with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _anim = Tween(begin: 0.0, end: 1.0).animate(_ctrl);
    _ctrl.forward();
  }
}
```''',
        ),

        // ─── DART ──────────────────────────────────────────────────────────
        CheatSheet(
          id: 'dart-essentials',
          title: 'Dart — Syntaxe essentielle',
          technology: 'Dart',
          tags: ['dart', 'flutter', 'programmation'],
          content: '''## Variables
```dart
var name = 'Alice';       // inférence
String name = 'Alice';    // typé
final name = 'Alice';     // immutable runtime
const pi = 3.14;          // immutable compile-time
String? name;             // nullable
late String name;         // initialisé plus tard
```

## Collections
```dart
List<String> items = ['a', 'b'];
items.add('c');
items.where((e) => e != 'a').toList();
items.map((e) => e.toUpperCase()).toList();

Map<String, int> scores = {'Alice': 10};
Set<String> tags = {'dart', 'flutter'};
```

## Async
```dart
Future<String> fetchData() async {
  final result = await someAsyncOp();
  return result;
}
```

## Null safety
```dart
String? name;
print(name?.length);        // safe navigation
print(name ?? 'default');   // fallback
if (name != null) print(name); // smart cast
```''',
        ),

        CheatSheet(
          id: 'dart-oop',
          title: 'Dart — POO & Patterns',
          technology: 'Dart',
          tags: ['dart', 'oop', 'class', 'mixin'],
          content: '''## Classe & Constructeurs
```dart
class Animal {
  final String name;
  int age;

  Animal(this.name, {required this.age});
  Animal.unnamed() : name = 'Unknown', age = 0;

  void speak() => print('...');
  String get description => '\$name (\$age ans)';
}
```

## Héritage & Interface
```dart
class Dog extends Animal {
  Dog(super.name, {required super.age});
  @override
  void speak() => print('Woof!');
}

abstract class Flyable {
  void fly();
}
class Bird extends Animal implements Flyable {
  @override
  void fly() => print('Flap flap');
}
```

## Mixin
```dart
mixin Swimmer {
  void swim() => print('Splash');
}
class Duck extends Animal with Swimmer {}
```

## Enum
```dart
enum Status { loading, success, error }
switch (status) {
  case Status.loading: print('...');
  case Status.success: print('OK');
  case Status.error:   print('Err');
}
```

## Extension
```dart
extension StringX on String {
  String get capitalized =>
    isEmpty ? this : '\${this[0].toUpperCase()}\${substring(1)}';
}
'hello'.capitalized; // 'Hello'
```''',
        ),

        // ─── JAVASCRIPT ────────────────────────────────────────────────────
        CheatSheet(
          id: 'javascript-essentials',
          title: 'JavaScript — Fondamentaux',
          technology: 'JavaScript',
          tags: ['javascript', 'js', 'web', 'frontend'],
          content: '''## Variables
```js
let x = 10;        // block-scoped, réassignable
const y = 20;      // block-scoped, immutable
var z = 30;        // function-scoped (éviter)
```

## Fonctions
```js
function greet(name) { return \`Hello \${name}\`; }
const greet = (name) => \`Hello \${name}\`;
const greet = name => \`Hello \${name}\`;
```

## Destructuring
```js
const { name, age } = user;
const [first, ...rest] = array;
const { a: renamed } = obj;
```

## Spread / Rest
```js
const merged = { ...obj1, ...obj2 };
const copy = [...arr1, ...arr2];
function sum(...nums) { return nums.reduce((a, b) => a + b); }
```

## Array methods
```js
arr.map(x => x * 2)
arr.filter(x => x > 0)
arr.reduce((acc, x) => acc + x, 0)
arr.find(x => x.id === 1)
arr.some(x => x > 10)
arr.every(x => x > 0)
arr.flat() / arr.flatMap(fn)
```

## Optional chaining & Nullish
```js
user?.address?.city
value ?? 'default'
user?.getName?.()
```''',
        ),

        CheatSheet(
          id: 'javascript-async',
          title: 'JavaScript — Async / Promises',
          technology: 'JavaScript',
          tags: ['javascript', 'async', 'promise', 'fetch'],
          content: '''## Promise
```js
const p = new Promise((resolve, reject) => {
  setTimeout(() => resolve('OK'), 1000);
});
p.then(val => console.log(val))
 .catch(err => console.error(err))
 .finally(() => console.log('done'));

Promise.all([p1, p2, p3])    // attend tous
Promise.race([p1, p2])       // premier résolu
Promise.allSettled([p1, p2]) // tous, même rejetés
```

## Async / Await
```js
async function fetchUser(id) {
  try {
    const res = await fetch(\`/api/users/\${id}\`);
    if (!res.ok) throw new Error('Not found');
    return await res.json();
  } catch (err) {
    console.error(err);
  }
}
```

## Fetch API
```js
// GET
const data = await fetch('/api/data').then(r => r.json());

// POST
await fetch('/api/users', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: 'Alice' }),
});
```

## Event Loop
```js
console.log('1');
setTimeout(() => console.log('3'), 0);
Promise.resolve().then(() => console.log('2'));
// Ordre : 1, 2, 3
```''',
        ),

        // ─── PYTHON ────────────────────────────────────────────────────────
        CheatSheet(
          id: 'python-essentials',
          title: 'Python — Fondamentaux',
          technology: 'Python',
          tags: ['python', 'scripting', 'backend'],
          content: '''## Types & Variables
```python
name: str = "Alice"
age: int = 25
pi: float = 3.14
active: bool = True
items: list[str] = ["a", "b"]
scores: dict[str, int] = {"Alice": 10}
tags: set[str] = {"python", "dev"}
```

## Conditions & Boucles
```python
if age >= 18:
    print("adulte")
elif age >= 13:
    print("ado")
else:
    print("enfant")

for item in items:
    print(item)

while n > 0:
    n -= 1
```

## List comprehension
```python
squares = [x**2 for x in range(10)]
evens = [x for x in range(20) if x % 2 == 0]
matrix = [[i*j for j in range(3)] for i in range(3)]
```

## Fonctions
```python
def greet(name: str, greeting: str = "Hello") -> str:
    return f"{greeting}, {name}!"

# Lambda
double = lambda x: x * 2

# Args & kwargs
def func(*args, **kwargs):
    print(args, kwargs)
```

## Gestion d'erreurs
```python
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Erreur: {e}")
finally:
    print("Terminé")
```''',
        ),

        CheatSheet(
          id: 'python-advanced',
          title: 'Python — Avancé & OOP',
          technology: 'Python',
          tags: ['python', 'oop', 'decorator', 'advanced'],
          content: '''## Classes
```python
class Animal:
    species = "Unknown"  # attribut de classe

    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age

    def __str__(self) -> str:
        return f"{self.name} ({self.age} ans)"

    @classmethod
    def from_dict(cls, data: dict) -> "Animal":
        return cls(data["name"], data["age"])

    @staticmethod
    def is_valid_age(age: int) -> bool:
        return age > 0

class Dog(Animal):
    def speak(self) -> str:
        return "Woof!"
```

## Décorateurs
```python
import functools

def timer(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        import time
        start = time.time()
        result = func(*args, **kwargs)
        print(f"{time.time() - start:.2f}s")
        return result
    return wrapper

@timer
def slow():
    time.sleep(1)
```

## Context Manager
```python
with open("file.txt", "r") as f:
    content = f.read()

class MyCtx:
    def __enter__(self): return self
    def __exit__(self, *args): pass
```

## Générateurs
```python
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

gen = fibonacci()
print(next(gen))  # 0, 1, 1, 2...
```''',
        ),

        // ─── DOCKER ────────────────────────────────────────────────────────
        CheatSheet(
          id: 'docker-essentials',
          title: 'Docker — Commandes essentielles',
          technology: 'Docker',
          tags: ['docker', 'container', 'devops', 'linux'],
          content: '''## Images
```bash
docker pull nginx            # télécharger une image
docker images                # lister les images
docker build -t app:v1 .     # construire depuis Dockerfile
docker rmi <image>           # supprimer une image
docker image prune           # supprimer les inutilisées
```

## Conteneurs
```bash
docker run -d -p 8080:80 --name web nginx
docker run -it ubuntu bash   # interactif
docker ps                    # conteneurs actifs
docker ps -a                 # tous les conteneurs
docker stop <id>
docker start <id>
docker rm <id>
docker logs -f <id>          # logs en temps réel
docker exec -it <id> bash    # entrer dans le conteneur
```

## Volumes & Réseau
```bash
docker volume create mydata
docker run -v mydata:/data nginx
docker run -v \$(pwd):/app node
docker network create mynet
docker run --network mynet nginx
```

## Nettoyage
```bash
docker system prune          # tout nettoyer
docker container prune
docker volume prune
```''',
        ),

        CheatSheet(
          id: 'docker-compose',
          title: 'Docker — Compose',
          technology: 'Docker',
          tags: ['docker', 'compose', 'devops', 'yaml'],
          content: '''## docker-compose.yml exemple
```yaml
version: '3.9'
services:
  api:
    build: ./api
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
    volumes:
      - ./api:/app

  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data

  nginx:
    image: nginx
    ports:
      - "80:80"
    depends_on:
      - api

volumes:
  pgdata:
```

## Commandes Compose
```bash
docker compose up -d         # démarrer en arrière-plan
docker compose down          # arrêter et supprimer
docker compose logs -f api   # logs d'un service
docker compose ps            # état des services
docker compose exec api bash # shell dans un service
docker compose build         # rebuilder les images
```''',
        ),

        // ─── TYPESCRIPT ────────────────────────────────────────────────────
        CheatSheet(
          id: 'typescript-essentials',
          title: 'TypeScript — Fondamentaux',
          technology: 'TypeScript',
          tags: ['typescript', 'ts', 'javascript', 'types'],
          content: '''## Types de base
```ts
let name: string = "Alice";
let age: number = 25;
let active: boolean = true;
let items: string[] = ["a", "b"];
let tuple: [string, number] = ["Alice", 25];
let value: string | number = "hello";  // union
let x: any;    // éviter
let y: unknown; // préférer any
```

## Interface & Type
```ts
interface User {
  id: number;
  name: string;
  email?: string;   // optionnel
  readonly role: string;
}

type Status = 'loading' | 'success' | 'error';
type ID = string | number;
type UserOrAdmin = User & { isAdmin: boolean };
```

## Fonctions typées
```ts
function greet(name: string): string {
  return \`Hello \${name}\`;
}

const add = (a: number, b: number): number => a + b;

function log(msg: string, level?: 'info' | 'error'): void {
  console.log(msg);
}
```

## Génériques
```ts
function identity<T>(value: T): T { return value; }
function first<T>(arr: T[]): T | undefined { return arr[0]; }

interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}
```

## Utility Types
```ts
Partial<User>         // tous les champs optionnels
Required<User>        // tous requis
Readonly<User>        // tout readonly
Pick<User, 'id'|'name'>
Omit<User, 'email'>
Record<string, number>
```''',
        ),

        // ─── REACT ─────────────────────────────────────────────────────────
        CheatSheet(
          id: 'react-essentials',
          title: 'React — Fondamentaux & Hooks',
          technology: 'React',
          tags: ['react', 'javascript', 'frontend', 'hooks'],
          content: '''## Composant fonctionnel
```tsx
interface Props {
  name: string;
  count?: number;
}

const MyComponent = ({ name, count = 0 }: Props) => {
  return <div>{name} — {count}</div>;
};
```

## Hooks courants
```tsx
// State
const [count, setCount] = useState(0);
const [user, setUser] = useState<User | null>(null);

// Effect
useEffect(() => {
  fetchData();
  return () => cleanup(); // cleanup
}, [dependency]);

// Ref
const inputRef = useRef<HTMLInputElement>(null);
inputRef.current?.focus();

// Memo & Callback
const value = useMemo(() => compute(a, b), [a, b]);
const handler = useCallback(() => doSomething(id), [id]);

// Context
const theme = useContext(ThemeContext);
```

## useReducer
```tsx
type Action = { type: 'increment' } | { type: 'reset' };

function reducer(state: number, action: Action): number {
  switch (action.type) {
    case 'increment': return state + 1;
    case 'reset': return 0;
  }
}

const [count, dispatch] = useReducer(reducer, 0);
dispatch({ type: 'increment' });
```

## Custom Hook
```tsx
function useFetch<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(url).then(r => r.json())
      .then(setData).finally(() => setLoading(false));
  }, [url]);

  return { data, loading };
}
```''',
        ),

        // ─── CSS ───────────────────────────────────────────────────────────
        CheatSheet(
          id: 'css-flexbox-grid',
          title: 'CSS — Flexbox & Grid',
          technology: 'CSS',
          tags: ['css', 'flexbox', 'grid', 'layout', 'frontend'],
          content: '''## Flexbox
```css
.container {
  display: flex;
  flex-direction: row;          /* row | column */
  justify-content: space-between; /* main axis */
  align-items: center;           /* cross axis */
  flex-wrap: wrap;
  gap: 16px;
}

.item {
  flex: 1;              /* grow, shrink, basis */
  flex: 0 0 200px;      /* fixed 200px */
  align-self: flex-end;
  order: 2;
}
```

## Grid
```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-columns: 200px 1fr 1fr;
  grid-template-rows: auto;
  gap: 16px;
  grid-template-areas:
    "header header"
    "sidebar main"
    "footer footer";
}

.header { grid-area: header; }
.item {
  grid-column: 1 / 3;   /* span 2 colonnes */
  grid-row: 1 / 3;
}
```

## Responsive
```css
/* Mobile first */
.card { width: 100%; }

@media (min-width: 768px) { .card { width: 50%; } }
@media (min-width: 1024px) { .card { width: 33%; } }

/* Container query */
@container (min-width: 400px) { .item { flex-direction: row; } }
```''',
        ),

        CheatSheet(
          id: 'css-modern',
          title: 'CSS — Moderne & Variables',
          technology: 'CSS',
          tags: ['css', 'variables', 'animation', 'modern'],
          content: '''## Variables CSS (Custom Properties)
```css
:root {
  --primary: #7c3aed;
  --bg: #0d1117;
  --radius: 8px;
  --shadow: 0 4px 12px rgba(0,0,0,0.3);
}

.button {
  background: var(--primary);
  border-radius: var(--radius);
  box-shadow: var(--shadow);
}
```

## Animations
```css
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to   { opacity: 1; transform: translateY(0); }
}

.element {
  animation: fadeIn 0.3s ease forwards;
  transition: all 0.2s ease;
}

.button:hover {
  transform: scale(1.05);
  filter: brightness(1.1);
}
```

## Pseudo-classes & éléments
```css
a:hover, a:focus {}
input:focus-visible {}
li:first-child, li:last-child {}
li:nth-child(2n) {}     /* pairs */
p:not(.excluded) {}
::before, ::after {}
::placeholder {}
```

## Sélecteurs avancés
```css
.parent > .direct-child {}
.a + .adjacent {}
.a ~ .siblings {}
[data-active="true"] {}
[href^="https"] {}    /* commence par */
[src\$=".png"] {}     /* finit par */
```''',
        ),

        // ─── NODE.JS ───────────────────────────────────────────────────────
        CheatSheet(
          id: 'nodejs-essentials',
          title: 'Node.js — Fondamentaux & Express',
          technology: 'Node.js',
          tags: ['nodejs', 'javascript', 'backend', 'express'],
          content: '''## Modules & Imports
```js
// CommonJS
const path = require('path');
const { readFile } = require('fs/promises');
module.exports = { myFunc };

// ESModules
import express from 'express';
import { readFile } from 'fs/promises';
export const myFunc = () => {};
```

## Filesystem
```js
import { readFile, writeFile, mkdir } from 'fs/promises';

const content = await readFile('./file.txt', 'utf-8');
await writeFile('./out.txt', 'Hello');
await mkdir('./dir', { recursive: true });
```

## Express basique
```js
import express from 'express';
const app = express();
app.use(express.json());

app.get('/users', async (req, res) => {
  const users = await db.findAll();
  res.json(users);
});

app.post('/users', async (req, res) => {
  const user = await db.create(req.body);
  res.status(201).json(user);
});

app.use((err, req, res, next) => {
  res.status(500).json({ error: err.message });
});

app.listen(3000, () => console.log('Server on :3000'));
```

## Middleware
```js
// Auth middleware
const auth = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  next();
};

app.use('/api', auth);
```''',
        ),

        // ─── HTTP / REST ───────────────────────────────────────────────────
        CheatSheet(
          id: 'http-rest',
          title: 'HTTP & REST API — Conventions',
          technology: 'HTTP',
          tags: ['http', 'rest', 'api', 'backend', 'web'],
          content: '''## Méthodes HTTP
```
GET     /users          → lister
GET     /users/1        → détail
POST    /users          → créer
PUT     /users/1        → remplacer entièrement
PATCH   /users/1        → modification partielle
DELETE  /users/1        → supprimer
```

## Codes de statut
```
200 OK               → succès
201 Created          → création réussie
204 No Content       → succès sans body (DELETE)
400 Bad Request      → données invalides
401 Unauthorized     → non authentifié
403 Forbidden        → non autorisé
404 Not Found        → ressource introuvable
409 Conflict         → conflit (email déjà pris...)
422 Unprocessable    → validation échouée
429 Too Many Requests→ rate limit
500 Server Error     → erreur interne
```

## Headers courants
```
Content-Type: application/json
Authorization: Bearer <token>
Accept: application/json
Cache-Control: no-cache
X-Request-ID: <uuid>
```

## Bonne pratique REST
```
✅ Noms de ressources au pluriel : /users, /posts
✅ Pas de verbe dans l'URL
✅ Versioning : /api/v1/users
✅ Pagination : ?page=1&limit=20
✅ Filtres : ?status=active&sort=name
✅ Retourner l'objet créé avec 201
✅ Messages d'erreur explicites
```''',
        ),

        // ─── LINUX ─────────────────────────────────────────────────────────
        CheatSheet(
          id: 'linux-sysadmin',
          title: 'Linux — Administration système',
          technology: 'Linux',
          tags: ['linux', 'sysadmin', 'terminal', 'server'],
          content: '''## Utilisateurs
```bash
whoami / id
useradd -m alice
passwd alice
usermod -aG sudo alice
userdel -r alice
groups alice
```

## Processus
```bash
top / htop
ps aux | grep node
kill -9 <pid>
pkill node
nohup ./script.sh &      # résiste à la déconnexion
systemctl status nginx
systemctl start/stop/restart nginx
journalctl -u nginx -f   # logs systemd
```

## Réseau
```bash
ip a                     # interfaces réseau
ss -tulnp                # ports ouverts
netstat -tlnp
curl -I https://google.com
wget <url>
scp file user@host:/path
rsync -avz src/ user@host:/dest
```

## Disque & Mémoire
```bash
df -h                    # espace disque
du -sh *                 # taille dossiers
free -h                  # mémoire
lsblk                    # disques
```

## Crontab
```bash
crontab -e
# MIN HH JJ MM WEEKDAY commande
  0   2  *  *  *  /backup.sh   # tous les jours à 2h
  */5 *  *  *  *  /check.sh    # toutes les 5 min
```''',
        ),

        // ─── JSON ──────────────────────────────────────────────────────────
        CheatSheet(
          id: 'json-jq',
          title: 'JSON & jq — Manipulation',
          technology: 'JSON',
          tags: ['json', 'jq', 'api', 'terminal'],
          content: '''## Structure JSON
```json
{
  "user": {
    "id": 1,
    "name": "Alice",
    "roles": ["admin", "dev"],
    "active": true,
    "score": 9.8,
    "meta": null
  }
}
```

## jq — Requêtes
```bash
cat data.json | jq '.'              # formater
jq '.user.name' data.json           # champ
jq '.users[0]' data.json            # index
jq '.users[].name' data.json        # itérer
jq '.users | length' data.json      # longueur
jq '.users | map(.name)' data.json  # mapper
jq '.users[] | select(.age > 18)' data.json
jq '{id: .id, name: .name}' data.json  # projeter
```

## JavaScript (JSON)
```js
// Parser
const obj = JSON.parse('{"name":"Alice"}');

// Sérialiser
const str = JSON.stringify(obj, null, 2);

// Deep clone simple
const clone = JSON.parse(JSON.stringify(obj));
```

## Validation & Schema (JSON Schema)
```json
{
  "type": "object",
  "required": ["name", "email"],
  "properties": {
    "name": { "type": "string", "minLength": 1 },
    "email": { "type": "string", "format": "email" },
    "age": { "type": "integer", "minimum": 0 }
  }
}
```''',
        ),

        // ─── MARKDOWN ──────────────────────────────────────────────────────
        CheatSheet(
          id: 'markdown-essentials',
          title: 'Markdown — Syntaxe complète',
          technology: 'Markdown',
          tags: ['markdown', 'documentation', 'readme'],
          content: '''## Titres & Texte
```
# H1  ## H2  ### H3  #### H4
**gras**   *italique*   ~~barré~~   `code inline`
> Citation
---   <!-- séparateur horizontal -->
```

## Listes
```
- item
  - sous-item
- item

1. Premier
2. Deuxième

- [x] Fait
- [ ] À faire
```

## Liens & Images
```
[texte](url)
[texte](url "titre")
![alt](image.png)
[![badge](img)](url)
```

## Code
````
`inline`

```python
def hello(): print("Hi")
```
````

## Tableaux
```
| Col1 | Col2 | Col3 |
|------|:----:|-----:|
| g    | c    | d    |
```

## Divers
```
<details>
<summary>Détails cachés</summary>
Contenu...
</details>

> [!NOTE]
> Note importante (GitHub Flavored Markdown)

> [!WARNING]
> Attention !
```''',
        ),
      ];
}
