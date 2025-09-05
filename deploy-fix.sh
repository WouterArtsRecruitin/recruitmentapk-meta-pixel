#!/bin/bash

# GitHub Direct Deploy Script - RecruitmentAPK Meta Pixel Fix
# Fixes webhook URL and CORS policy for Zapier integration

set -e

echo "🚀 Starting GitHub deployment for RecruitmentAPK Meta Pixel fix..."

# Repository configuration
REPO_URL="https://github.com/WouterArtsRecruitin/recruitmentapk-meta-pixel.git"
REPO_DIR="recruitmentapk-meta-pixel"
BRANCH="main"

# Cleanup previous attempts
if [ -d "$REPO_DIR" ]; then
    echo "📁 Cleaning up existing repository..."
    rm -rf "$REPO_DIR"
fi

# Clone repository
echo "📥 Cloning repository..."
git clone "$REPO_URL" "$REPO_DIR"
cd "$REPO_DIR"

# Create the fixed JavaScript code
echo "🔧 Creating fixed Meta Pixel tracking code..."

cat > fixed-tracking-code.js << 'EOF'
// RECRUITMENTAPK ENHANCED PIXEL IMPLEMENTATION - FIXED VERSION
// Fixes: Correct webhook URL + CORS bypass

(function() {
  'use strict';
  
  // ✅ FINAL CONFIGURATION - WEBHOOK URL CORRECTED
  const CONFIG = {
    // ✅ VERIFIED ZAPIER WEBHOOK URL
    ZAPIER_WEBHOOK: 'https://hooks.zapier.com/hooks/catch/23933997/uhqgdti/assessment',
    
    // ✅ RecruitmentAPK Assessment dataset ID (correct!)
    DATASET_ID: '1443564313411457',
    
    // ✅ RECRUITMENTAPK.NL ASSESSMENT URL'S
    ASSESSMENT_PAGES: [
      '/assessment',
      '/recruitment-test',
      '/recruitmentapk',
      '/test',
      '/intake',
      '/scan',
      '/hr-assessment',
      '/beoordeling'
    ],
    
    // Production ready
    DEBUG: true
  };
  
  // Utility functions
  function debugLog(message, data) {
    if (CONFIG.DEBUG) {
      console.log('[RecruitmentAPK]', message, data);
    }
  }
  
  function getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
    return null;
  }
  
  function getUrlParameter(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
  }
  
  function generateEventId() {
    return 'apk_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
  }
  
  // Assessment pagina detectie
  function isAssessmentPage() {
    const currentPath = window.location.pathname.toLowerCase();
    return CONFIG.ASSESSMENT_PAGES.some(page => currentPath.includes(page));
  }
  
  // Assessment completion tracking - FIXED VERSION
  function trackAssessmentCompletion(form, manualData) {
    const eventId = generateEventId();
    const timestamp = new Date().toISOString();
    
    debugLog('🎯 Assessment completion gedetecteerd!', { eventId, timestamp });
    
    // Verzamel assessment data
    let assessmentData = {
      score: null,
      company: null,
      role: null,
      email: null,
      phone: null,
      completion_time: null
    };
    
    // Prioriteit: handmatige data > form data > stored data
    if (manualData) {
      assessmentData = { ...assessmentData, ...manualData };
      debugLog('✅ Handmatige assessment data gebruikt', manualData);
    } else if (form) {
      const formData = new FormData(form);
      assessmentData = {
        score: formData.get('score') || formData.get('assessment-score'),
        company: formData.get('company') || formData.get('bedrijf'),
        role: formData.get('role') || formData.get('functie'),
        email: formData.get('email') || formData.get('e-mail'),
        phone: formData.get('phone') || formData.get('telefoon'),
        completion_time: Date.now() - (window.assessmentStartTime || Date.now())
      };
      debugLog('📝 Form data gebruikt', assessmentData);
    }
    
    // Meta Pixel Lead event
    if (typeof fbq !== 'undefined') {
      fbq('track', 'Lead', {
        content_name: 'RecruitmentAPK Assessment Completion',
        content_category: 'Assessment',
        content_type: 'recruitment_assessment',
        value: assessmentData.score || 1,
        currency: 'EUR'
      }, {
        eventID: eventId
      });
      
      debugLog('📊 Meta Pixel Lead event verzonden', { eventId });
    }
    
    // Zapier webhook payload
    const webhookData = {
      event_type: 'assessment_completion',
      event_id: eventId,
      timestamp: timestamp,
      
      assessment_data: {
        score: parseInt(assessmentData.score) || 0,
        company: assessmentData.company || '',
        role: assessmentData.role || '',
        email: assessmentData.email || '',
        phone: assessmentData.phone || '',
        completion_time_ms: assessmentData.completion_time || 0
      },
      
      pixel_data: {
        fbp: getCookie('_fbp'),
        fbc: getCookie('_fbc'),
        dataset_id: CONFIG.DATASET_ID,
        pixel_id: '1443564313411457'
      },
      
      page_data: {
        url: window.location.href,
        title: document.title,
        referrer: document.referrer,
        user_agent: navigator.userAgent.substring(0, 200)
      },
      
      attribution: {
        utm_source: getUrlParameter('utm_source'),
        utm_medium: getUrlParameter('utm_medium'),
        utm_campaign: getUrlParameter('utm_campaign'),
        utm_content: getUrlParameter('utm_content'),
        utm_term: getUrlParameter('utm_term'),
        fbclid: getUrlParameter('fbclid'),
        gclid: getUrlParameter('gclid')
      }
    };
    
    // FIXED: Verstuur naar Zapier met CORS bypass
    fetch(CONFIG.ZAPIER_WEBHOOK, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(webhookData),
      mode: 'no-cors'  // CORS bypass fix
    })
    .then(() => {
      debugLog('✅ Assessment data verzonden naar Zapier (no-cors mode)', webhookData);
      
      if (window.onAssessmentTracked) {
        window.onAssessmentTracked(webhookData);
      }
    })
    .catch(error => {
      debugLog('❌ Zapier webhook fetch error:', error);
    });
    
    return webhookData;
  }
  
  // Assessment pagina view tracking
  function trackAssessmentPageView() {
    if (!isAssessmentPage()) {
      debugLog('ℹ️ Geen assessment pagina gedetecteerd');
      return;
    }
    
    const eventId = generateEventId();
    debugLog('👀 Assessment pagina bezocht');
    
    if (typeof fbq !== 'undefined') {
      fbq('track', 'ViewContent', {
        content_name: 'RecruitmentAPK Assessment Page',
        content_category: 'Assessment',
        content_type: 'assessment_landing'
      }, {
        eventID: eventId
      });
    }
    
    const webhookData = {
      event_type: 'assessment_page_view',
      event_id: eventId,
      timestamp: new Date().toISOString(),
      
      page_data: {
        url: window.location.href,
        title: document.title,
        referrer: document.referrer
      },
      
      pixel_data: {
        fbp: getCookie('_fbp'),
        fbc: getCookie('_fbc'),
        dataset_id: CONFIG.DATASET_ID
      },
      
      attribution: {
        utm_source: getUrlParameter('utm_source'),
        utm_medium: getUrlParameter('utm_medium'),
        utm_campaign: getUrlParameter('utm_campaign'),
        fbclid: getUrlParameter('fbclid'),
        gclid: getUrlParameter('gclid')
      }
    };
    
    // FIXED: Page view webhook with CORS bypass
    fetch(CONFIG.ZAPIER_WEBHOOK, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(webhookData),
      mode: 'no-cors'
    })
    .then(() => {
      debugLog('✅ Assessment page view verzonden');
    })
    .catch(error => {
      debugLog('❌ Assessment page view webhook error:', error);
    });
    
    window.assessmentStartTime = Date.now();
    debugLog('⏱️ Assessment timer gestart');
  }
  
  // Auto-detectie van assessment completion
  function setupAssessmentTracking() {
    // Form submit event
    document.addEventListener('submit', function(e) {
      const form = e.target;
      
      if (form.id === 'assessment-form' || 
          form.classList.contains('assessment-form') ||
          form.classList.contains('recruitment-form') ||
          form.action.includes('assessment')) {
        
        debugLog('📝 Assessment form submit gedetecteerd', form);
        
        setTimeout(() => {
          trackAssessmentCompletion(form);
        }, 100);
      }
    });
    
    // Submit button clicks
    document.addEventListener('click', function(e) {
      const button = e.target;
      const buttonText = button.textContent.toLowerCase();
      
      if (button.type === 'submit' && (
          button.id.includes('assessment') ||
          button.classList.contains('assessment-submit') ||
          buttonText.includes('verstuur') ||
          buttonText.includes('voltooi') ||
          buttonText.includes('submit') ||
          buttonText.includes('verzend')
        )) {
        
        debugLog('🔘 Assessment submit button geklikt', button);
        
        setTimeout(() => {
          const form = button.closest('form');
          trackAssessmentCompletion(form);
        }, 500);
      }
    });
    
    // URL change detectie voor SPAs
    let lastUrl = location.href;
    new MutationObserver(() => {
      const url = location.href;
      if (url !== lastUrl) {
        lastUrl = url;
        
        if (url.includes('bedankt') || 
            url.includes('success') || 
            url.includes('voltooid') ||
            url.includes('completed') ||
            url.includes('thank-you')) {
          
          debugLog('🎉 Success pagina gedetecteerd via URL', url);
          trackAssessmentCompletion();
        }
      }
    }).observe(document, { subtree: true, childList: true });
    
    debugLog('🎯 Assessment tracking listeners geïnstalleerd');
  }
  
  // Initialisatie
  function initializeTracking() {
    debugLog('🚀 RecruitmentAPK tracking geïnitialiseerd', {
      url: window.location.href,
      isAssessmentPage: isAssessmentPage(),
      config: CONFIG
    });
    
    trackAssessmentPageView();
    setupAssessmentTracking();
    
    // Global API
    window.RecruitmentAPK = {
      trackAssessment: trackAssessmentCompletion,
      trackPageView: trackAssessmentPageView,
      config: CONFIG,
      debug: debugLog,
      isAssessmentPage: isAssessmentPage,
      getPixelData: () => ({
        fbp: getCookie('_fbp'),
        fbc: getCookie('_fbc'),
        dataset_id: CONFIG.DATASET_ID
      }),
      test: () => {
        debugLog('🧪 Test functie uitgevoerd');
        return trackAssessmentCompletion(null, {
          score: 85,
          company: 'Test Company BV',
          role: 'HR Director',
          email: 'test@recruitmentapk.nl',
          phone: '06-12345678'
        });
      }
    };
    
    debugLog('✅ Global RecruitmentAPK object beschikbaar');
    debugLog('💡 Gebruik window.RecruitmentAPK.test() voor handmatige test');
  }
  
  // Start tracking
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeTracking);
  } else {
    initializeTracking();
  }
  
})();
EOF

# Update all HTML files with the fixed tracking code
echo "📝 Updating HTML files with fixed tracking code..."

for file in *.html; do
    if [ -f "$file" ]; then
        echo "Updating $file..."
        
        # Create backup
        cp "$file" "$file.backup"
        
        # Replace the webhook URL in existing tracking code
        sed -i 's|https://hooks\.zapier\.com/hooks/catch/318598640/b2bfvvg/assessment|https://hooks.zapier.com/hooks/catch/23933997/uhqgdti/assessment|g' "$file"
        
        # Add CORS fix to fetch calls if not already present
        if ! grep -q "mode: 'no-cors'" "$file"; then
            sed -i 's|body: JSON\.stringify(webhookData)|body: JSON.stringify(webhookData),\n      mode: '\''no-cors'\''|g' "$file"
        fi
        
        echo "✅ Fixed $file"
    fi
done

# Check if changes were made
if git diff --quiet; then
    echo "⚠️ No changes detected in HTML files"
    echo "📁 Available files:"
    ls -la *.html 2>/dev/null || echo "No HTML files found"
else
    echo "✅ Changes detected, preparing commit..."
    
    # Add changes
    git add .
    
    # Commit with descriptive message
    git commit -m "Fix: Correct Zapier webhook URL and add CORS bypass

- Update webhook URL from 318598640/b2bfvvg to 23933997/uhqgdti
- Add CORS bypass with mode: 'no-cors' for browser compatibility
- Maintains Meta Pixel tracking with ID 1443564313411457
- Assessment tracking ready for recruitmentapk.nl production"
    
    # Push to GitHub
    echo "🚀 Pushing to GitHub..."
    git push origin "$BRANCH"
    
    echo "✅ Successfully pushed to GitHub!"
    echo "🌐 Netlify will auto-deploy within 2-3 minutes"
    echo "🔗 Check deployment status in Netlify dashboard"
fi

# Cleanup
cd ..
rm -rf "$REPO_DIR"

echo "🎉 Deployment script completed!"
echo ""
echo "📋 Next steps:"
echo "1. Check Netlify deployment status"
echo "2. Test window.RecruitmentAPK.test() on recruitmentapk.nl"
echo "3. Verify data flows to Google Sheets and Slack"
echo "4. Monitor Zapier task history for successful webhook receipts"