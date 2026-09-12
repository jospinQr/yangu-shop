# 🛒 YanguShop - Marketplace Butembo (RDC)

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-State_Management-777BB4?style=for-the-badge)](https://riverpod.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**YanguShop** est une solution de marketplace moderne et résiliente, conçue spécifiquement pour l'écosystème commercial de la ville de **Butembo** en République Démocratique du Congo. L'application connecte les acheteurs locaux aux vendeurs des grands centres commerciaux et galeries, tout en répondant aux défis technologiques locaux (connectivité instable, coût des données, diversité des appareils).

---

## 🌟 Fonctionnalités Principales

- 🔍 **Recherche Ultra-Rapide** : Trouvez instantanément des produits parmi des milliers de références locales.
- 📍 **Géolocalisation Intelligente** : Localisez les produits et boutiques selon votre position ou des critères spécifiques (quartier, proximité).
- 🏢 **Exploration de Galeries & Centres** : Naviguez virtuellement dans les centres commerciaux et galeries célèbres de Butembo pour découvrir les boutiques physiques.
- 🤝 **Mise en Relation Directe** : Contactez facilement les vendeurs pour négocier ou finaliser un achat (Intégration WhatsApp/Appel).
- 🛒 **Gestion de Panier** : Préparez vos achats de manière intuitive avant la validation.
- 📶 **Mode Résilient (Offline-Ready)** : Consultation fluide même en cas de faible débit ou de coupure réseau.

---

## 🛠 Stack Technique

L'application repose sur une architecture robuste inspirée du **Clean Architecture** (Android MVVM) pour garantir maintenabilité et testabilité.

- **Framework** : Flutter 3.x
- **Gestion d'État & DI** : [Riverpod](https://riverpod.dev) (Générateurs)
- **Navigation** : [GoRouter](https://pub.dev/packages/go_router)
- **Networking** : [Dio](https://pub.dev/packages/dio) & [Retrofit](https://pub.dev/packages/retrofit)
- **Modèles** : [Freezed](https://pub.dev/packages/freezed) (Immuabilité)
- **Localisation** : Support multi-devises (CDF/USD) et interface en Français.

---

## 🏗 Architecture

Le projet suit une structure **Feature-First Clean Architecture** :

```text
lib/
 ├── app/          # Configuration globale (thème, router)
 ├── core/         # Code transverse (réseau, erreurs, utils)
 └── features/     # Dossiers par domaine métier
      └── <feature>/
           ├── data/        # DTOs, Mappers & Repositories impl.
           ├── domain/      # Entités & Contrats de repositories
           └── presentation/# Pages, Controllers (Riverpod) & Widgets
```

---

## 🚀 Installation & Lancement

### Prérequis
- Flutter SDK (dernière version stable)
- Android Studio / VS Code
- Un émulateur ou appareil physique

### Étapes
1. **Cloner le projet**
   ```bash
   git clone https://github.com/votre-username/bbo_shop_app.git
   cd bbo_shop_app
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer le code (Models/Retrofit)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Que ce soit pour corriger un bug, améliorer la UI ou ajouter une fonctionnalité :

1. Forkez le projet.
2. Créez votre branche (`git checkout -b feature/AmazingFeature`).
3. Commitez vos changements (`git commit -m 'Add some AmazingFeature'`).
4. Pushez sur la branche (`git push origin feature/AmazingFeature`).
5. Ouvrez une Pull Request.

*Note : Les messages de commit et la documentation technique sont en Anglais, mais l'interface utilisateur reste en Français.*

---

## 🌍 Contexte Local (RDC)
Ce projet accorde une importance particulière à :
- **L'économie de data** : Optimisation du poids des images.
- **Le multi-devises** : Gestion native des prix en Franc Congolais (CDF) et Dollar (USD).
- **L'accessibilité** : Performance optimale sur des appareils Android d'entrée de gamme.

---

## 📄 Licence
Distribué sous la licence MIT. Voir `LICENSE` pour plus d'informations.

---

## 📬 Contact
Lien du projet : [https://github.com/votre-username/bbo_shop_app](https://github.com/votre-username/bbo_shop_app)

---
*Fait avec ❤️ pour la communauté de Butembo.*
