## Full-stack iOS приложение (Front-end)

## Технологический стек
| Категория               | Технологии                                           |
|-------------------------|------------------------------------------------------|
| Языки                   | Swift (Front-end & Back-end)                         |
| Фреймворки              | SwiftUI, Vapor                                       |
| База данных             | Yandex PostgreSQL (Raw SQL)                          |
| Persistence             | UserDefaults, Keychain (Secure Storage)              |
| Инфраструктура          | Docker, Fly.io (Deployment)                          |
| Хранилище               | Yandex Object Storage                                |
| Работа с сетью          | URLSession (Async/await), REST API                   |
| Асинхронность           | Async/await, Combine, GCD                            |
| Архитектура и принципы  | MVVM, SOLID, DRY, KISS, YAGNI, Design Patterns       |
| Инструменты             | Git, Swift Package Manager                           |


<table>
  <tr>
    <td align="center">
      <d>Главная страница</d>
      <video src="https://github.com/user-attachments/assets/5f498c79-e4bd-4bd7-a2aa-f4c3432c787c" width="200" autoplay loop muted title=""></video>
    </td>
    <td align="center">
      <d>Поиск</d>
      <video src="https://github.com/user-attachments/assets/d0ae6674-a159-4d8f-9f08-4a37c0ec0fe4" width="200" autoplay loop muted title=""></video>
    </td>
    <td align="center">
      <d>Детали контента</d>
      <video src="https://github.com/user-attachments/assets/3e2293d2-4c53-4e88-b500-3f5dc19ac105" width="200" autoplay loop muted title=""></video>
    </td>
    <td align="center">
      <d>Избранное</d>
      <video src="https://github.com/user-attachments/assets/563b0e2d-fd50-4152-bf00-5a00905bfa92" width="200" autoplay loop muted title=""></video>
    </td>
  </tr>
  <tr>
    <td align="center">
      <d>Вход</d>
      <video src="https://github.com/user-attachments/assets/55e81442-6bcd-4eba-9a45-4bbc7ff9e9f8" width="200" autoplay loop muted title=""></video>
    </td>
    <td align="center">
      <d>Регистрация</d>
      <video src="https://github.com/user-attachments/assets/c9e72433-31bf-4355-9a71-919fd043e305" width="200" autoplay loop muted title=""></video>
    </td>
    <td align="center">
      <d>Смена темы</d>
      <video src="https://github.com/user-attachments/assets/3a0951a7-b0aa-4373-81f4-a3e9a913d1bf" width="200" autoplay loop muted title=""></video>
    </td>
  </tr>
</table>

## Визуальная структура БД Yandex PostgreSQL 
<img width="338" height="398" alt="image" src="https://github.com/user-attachments/assets/e43c3973-89a2-4f7b-ba3d-d3b364a959d8" />

## Описание приложения
* Главная страница: Включает "Head" статью с приоритетным отображением, горизонтальный скролл популярных мест и вертикальную основную ленту.
* Умная пагинация: Реализована рандомизация на стороне сервера (сортировка по MD5-хешу с использованием Seed). Это позволяет пользователю видеть уникальную "перемешанную" ленту, в которой элементы никогда не дублируются при бесконечном скролле.
* Поиск и Фильтрация: Возможность полнотекстового поиска (ILIKE) по статьям и фильтрация по категориям. Данные обновляются в реальном времени с поддержкой пагинации для результатов поиска.
* Детализация контента: Каждая статья содержит детальное описание, галерею изображений, информацию о времени чтения и категории.
* Избранное: Система лайков работает в режиме "Optimistic UI" — состояние обновляется локально мгновенно, а синхронизация с сервером происходит в фоновом режиме.
* Профиль и настройки:
  Авторизация и регистрация: Полноценная система входа и регистрации (JWT), безопасное хранение токенов в Keychain и данных пользователя в UserDefaults.
  Управление темой: Поддержка Светлой, Темной и Системной темы.
  Удобные разделы для переходов в корзину и любимое.  
