# RecruitmentAPK Automation System

Volledig geautomatiseerd backend integratie systeem voor RecruitmentAPK met Zapier, Pipedrive, lead scoring, email templates en PDF generatie.

## 🚀 Overzicht

Dit systeem biedt een complete automatisering voor het verwerken van recruitment assessments met:

- **Lead Scoring**: 0-300 punten systeem met A+/A/B/C/D classificatie
- **Zapier Integratie**: Volledige webhook payload met alle assessment data
- **Pipedrive CRM**: Automatisch aanmaken van persons, organizations, deals en custom fields
- **Lead Tags**: Intelligente tagging gebaseerd op score, rol, ervaring en urgentie
- **Email Templates**: Dynamische template selectie gebaseerd op lead kwaliteit
- **PDF Rapporten**: Professionele gestylde rapporten met lead score breakdown

## 📁 Bestanden

1. **recruitmentapk-version-b.html** - Hoofdbestand met alle integraties
2. **complete-automation-test.js** - Test script voor console testing
3. **automation-dashboard.html** - Visueel dashboard voor monitoring

## 🎯 Lead Scoring Systeem

### Score Componenten (Max 300 punten)
- **Basis Score**: 100 punten
- **Ervaring Niveau**: 
  - Junior: 50 punten
  - Medior: 75 punten
  - Senior: 100 punten
- **Rol Complexiteit**:
  - Frontend: 60 punten
  - Backend: 70 punten
  - DevOps: 85 punten
  - FullStack: 90 punten
- **Locatie Voorkeur**:
  - Office: 70 punten
  - Remote: 80 punten
  - Hybrid: 90 punten
- **Service Level**:
  - Basic: 20 punten
  - Premium: 50 punten
  - Enterprise: 100 punten

### Lead Classificaties
- **A+ (Hot Lead)**: 250-300 punten
- **A (Hoge Kwaliteit)**: 200-249 punten
- **B (Goede Kwaliteit)**: 150-199 punten
- **C (Basis Kwaliteit)**: 100-149 punten
- **D (Lage Kwaliteit)**: <100 punten

## 🔧 Gebruik

### In Browser Console

```javascript
// Test complete automatisering
runCompleteTest();

// Simuleer live submission
simulateLiveSubmission({
    role: 'fullstack',
    experience: 'senior',
    location: 'hybrid',
    service: 'enterprise'
});

// Test webhooks (dry run)
testWebhooks(true);

// Bereken score breakdown
calculateScoreBreakdown({
    role: 'backend',
    experience: 'medior',
    location: 'remote',
    service: 'premium'
});
```

### Dashboard

Open `automation-dashboard.html` in browser voor:
- Real-time lead score monitoring
- Webhook status tracking
- Payload preview
- Test scenario's uitvoeren

## 🔌 Webhook Endpoints

Het systeem stuurt automatisch data naar:

1. **Zapier**: `https://hooks.zapier.com/hooks/catch/recruitmentapk/`
2. **Pipedrive**: `https://webhooks.pipedrive.com/recruitmentapk/`
3. **Email Service**: `https://api.emailservice.com/send/`

## 📊 Data Structuur

### Zapier Payload
```json
{
  "timestamp": "2024-01-01T12:00:00.000Z",
  "source": "RecruitmentAPK Smart Assessment",
  "leadScore": 275,
  "leadGrade": "A+ (Hot Lead)",
  "leadTags": ["RecruitmentAPK", "Rol-fullstack", "Hot-Lead"],
  "assessment": {
    "role": "fullstack",
    "experience": "senior",
    "location": "hybrid",
    "service": "enterprise"
  }
}
```

### Pipedrive Custom Fields
- `lead_score`: Numerieke score (0-300)
- `lead_grade`: Tekst classificatie
- `assessment_role`: Geselecteerde rol
- `assessment_experience`: Ervaring niveau
- `assessment_location`: Locatie voorkeur
- `preferred_service`: Gekozen service pakket
- `urgency_level`: Hoog/Gemiddeld/Laag

## 🎨 Email Templates

Het systeem selecteert automatisch de juiste template:

1. **Hot Lead** (250+ punten)
   - Subject: "🚀 Perfecte match gevonden!"
   - Priority: High
   
2. **Qualified Lead** (200-249 punten)
   - Subject: "✨ Sterke matches beschikbaar"
   - Priority: Medium
   
3. **Standard Lead** (150-199 punten)
   - Subject: "📋 Uw assessment - Volgende stappen"
   - Priority: Normal
   
4. **Nurture Lead** (<150 punten)
   - Subject: "💡 Recruitment tips voor u"
   - Priority: Low

## 📈 Analytics

Het systeem integreert met Google Analytics:
```javascript
gtag('event', 'assessment_completed', {
    'lead_score': 275,
    'lead_grade': 'A+ (Hot Lead)',
    'service_selected': 'enterprise'
});
```

## 🚀 Deployment

1. Upload alle bestanden naar webserver
2. Configureer webhook URLs in backend code
3. Test met automation dashboard
4. Monitor via console logs

## 📝 Notities

- Alle webhooks hebben error handling met fallback
- PDF generatie werkt client-side met jsPDF
- Lead tags worden automatisch gegenereerd
- Systeem is volledig Nederlands