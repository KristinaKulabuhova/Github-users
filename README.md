## Приложение, главная страница которого содержит TabBar с двумя вкладками: “Пользователи” и “Emoji”

**Экран - “Пользователи”**
1. Отображается список всех пользователей GitHub. 
Используется API:
https://developer.github.com/v3/users/#get-all-users
2. В элементе списка отрисованы: Avatar, login (title) и id (subtitle)
  a. картинка должна располагаться слева посередине
  b. title и subtitle прикреплены к правому краю картинки
  c. title и subtitle должны располагаться по центру относительно картинки
3. По нажатию на элемент списка реализуется переход в “Детали пользователя”
4. Реализовано pagination и pull-to-refresh

**Экран - “Emoji”**
1. Отображается список всех emoji. 
Используется API: 
https://docs.github.com/en/rest/emojis#get-emojis
2. Для отображения emoji используется CollectionView

**Экран - “Детали пользователя”**
1. Используется API: https://docs.github.com/en/rest/users/users#get-a-user
2. Заголовок экрана - логин пользователя
3. Отображаются поля, если есть:
  a. Avatar
  b. name
  c. email
  d. organization
  e. following count
  f. followers count
  g. дату создания аккаунта
