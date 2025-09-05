// ============================================
// RECRUITMENTAPK COMPLETE AUTOMATION TEST SCRIPT
// ============================================

// Dit script demonstreert en test alle backend integratie functies
// Voor gebruik in de browser console op de RecruitmentAPK pagina

console.log('🚀 RecruitmentAPK Automation Test Script Starting...\n');

// Test Data Sets
const testScenarios = [
    {
        name: "Hot Lead - Senior FullStack Developer",
        data: {
            role: 'fullstack',
            experience: 'senior',
            location: 'hybrid',
            service: 'enterprise'
        },
        expectedScore: 365, // 100 + 100 + 90 + 90 + 85 (capped at 300)
        expectedGrade: 'A+ (Hot Lead)'
    },
    {
        name: "Qualified Lead - Medior Backend Developer",
        data: {
            role: 'backend',
            experience: 'medior',
            location: 'remote',
            service: 'premium'
        },
        expectedScore: 275, // 100 + 75 + 70 + 80 + 50
        expectedGrade: 'A+ (Hot Lead)'
    },
    {
        name: "Standard Lead - Junior Frontend Developer",
        data: {
            role: 'frontend',
            experience: 'junior',
            location: 'office',
            service: 'basic'
        },
        expectedScore: 200, // 100 + 50 + 60 + 70 + 20
        expectedGrade: 'A (Hoge Kwaliteit)'
    },
    {
        name: "Nurture Lead - Junior Developer No Service",
        data: {
            role: 'frontend',
            experience: 'junior',
            location: 'office'
        },
        expectedScore: 180, // 100 + 50 + 60 + 70 + 0
        expectedGrade: 'B (Goede Kwaliteit)'
    }
];

// Test Functions
function runCompleteTest() {
    console.log('📊 Testing All Scenarios...\n');
    
    testScenarios.forEach((scenario, index) => {
        console.log(`\n===== Test ${index + 1}: ${scenario.name} =====`);
        testScenario(scenario);
    });
    
    console.log('\n\n✅ All tests completed!');
}

function testScenario(scenario) {
    const { data, expectedScore, expectedGrade } = scenario;
    
    // Test Lead Scoring
    const score = calculateLeadScore(data);
    const grade = getLeadGrade(score);
    console.log(`📈 Lead Score: ${score} (expected: ${Math.min(expectedScore, 300)})`);
    console.log(`🎯 Lead Grade: ${grade} (expected: ${expectedGrade})`);
    
    // Test Lead Tags
    const tags = generateLeadTags(data);
    console.log(`🏷️  Lead Tags: ${tags.join(', ')}`);
    
    // Test Zapier Payload
    const zapierPayload = generateZapierPayload(data);
    console.log(`📤 Zapier Payload:`, zapierPayload);
    
    // Test Pipedrive Payload
    const pipedrivePayload = generatePipedrivePayload(data);
    console.log(`🔧 Pipedrive Deal Value: €${pipedrivePayload.deal.value}`);
    console.log(`📊 Pipedrive Probability: ${pipedrivePayload.deal.probability}%`);
    
    // Test Email Template Selection
    const emailTemplate = selectEmailTemplate(data);
    console.log(`📧 Email Template: ${emailTemplate.template} (priority: ${emailTemplate.priority})`);
    console.log(`📧 Email Subject: ${emailTemplate.subject}`);
}

// Live Testing Functions
function simulateLiveSubmission(testData = null) {
    console.log('\n🎯 Simulating Live Submission...\n');
    
    const data = testData || {
        role: 'fullstack',
        experience: 'senior',
        location: 'hybrid',
        service: 'enterprise'
    };
    
    // Update global assessmentData
    window.assessmentData = data;
    
    console.log('📝 Assessment Data:', data);
    
    // Generate all payloads
    const zapierPayload = generateZapierPayload(data);
    const pipedrivePayload = generatePipedrivePayload(data);
    const emailPayload = generateEmailPayload(data);
    
    console.log('\n📤 Generated Payloads:');
    console.log('Zapier:', zapierPayload);
    console.log('Pipedrive:', pipedrivePayload);
    console.log('Email:', emailPayload);
    
    // Generate PDF preview
    console.log('\n📄 Generating PDF Preview...');
    const doc = generateProfessionalPDF(data);
    
    // Show preview in new tab
    const pdfBlob = doc.output('blob');
    const pdfUrl = URL.createObjectURL(pdfBlob);
    console.log('PDF Preview URL:', pdfUrl);
    console.log('💡 Tip: Copy and paste this URL in a new tab to view the PDF');
    
    return {
        zapier: zapierPayload,
        pipedrive: pipedrivePayload,
        email: emailPayload,
        pdfUrl: pdfUrl
    };
}

// Webhook Testing (Dry Run)
async function testWebhooks(dryRun = true) {
    console.log(`\n🔌 Testing Webhooks (${dryRun ? 'Dry Run' : 'Live'})...\n`);
    
    const testData = {
        role: 'devops',
        experience: 'senior',
        location: 'remote',
        service: 'premium'
    };
    
    if (dryRun) {
        console.log('🏃 DRY RUN - No actual webhooks will be called');
        const payloads = simulateLiveSubmission(testData);
        
        console.log('\n📋 Webhook URLs that would be called:');
        console.log('1. Zapier: https://hooks.zapier.com/hooks/catch/recruitmentapk/');
        console.log('2. Pipedrive: https://webhooks.pipedrive.com/recruitmentapk/');
        console.log('3. Email Service: https://api.emailservice.com/send/');
        
        return payloads;
    } else {
        console.log('🚀 LIVE RUN - Calling actual webhooks');
        window.assessmentData = testData;
        await submitToBackend(testData);
    }
}

// Analytics Testing
function testAnalytics() {
    console.log('\n📊 Testing Analytics Integration...\n');
    
    if (typeof gtag !== 'undefined') {
        console.log('✅ Google Analytics detected');
        
        // Simulate analytics event
        const testEvent = {
            'lead_score': 275,
            'lead_grade': 'A+ (Hot Lead)',
            'service_selected': 'premium'
        };
        
        console.log('📤 Sending test event:', testEvent);
        gtag('event', 'assessment_completed_test', testEvent);
        
        console.log('✅ Analytics event sent successfully');
    } else {
        console.log('⚠️  Google Analytics not detected on this page');
    }
}

// Lead Score Calculator
function calculateScoreBreakdown(data) {
    console.log('\n📊 Lead Score Breakdown:\n');
    
    const components = {
        'Base Score': 100,
        'Experience Bonus': {
            'junior': 50,
            'medior': 75,
            'senior': 100
        }[data.experience] || 50,
        'Role Complexity': {
            'frontend': 60,
            'backend': 70,
            'fullstack': 90,
            'devops': 85
        }[data.role] || 60,
        'Location Preference': {
            'remote': 80,
            'hybrid': 90,
            'office': 70
        }[data.location] || 70,
        'Service Level': {
            'basic': 20,
            'premium': 50,
            'enterprise': 100
        }[data.service] || 0
    };
    
    let total = 0;
    for (const [component, score] of Object.entries(components)) {
        console.log(`${component}: ${score} punten`);
        total += score;
    }
    
    console.log(`\nTotal: ${total} punten`);
    console.log(`Final Score (capped): ${Math.min(total, 300)} punten`);
    console.log(`Grade: ${getLeadGrade(Math.min(total, 300))}`);
    
    return Math.min(total, 300);
}

// Quick Commands
console.log('\n🎮 Quick Commands Available:\n');
console.log('runCompleteTest() - Run all test scenarios');
console.log('simulateLiveSubmission() - Simulate a live submission');
console.log('testWebhooks(false) - Test webhooks (set to false for live run)');
console.log('testAnalytics() - Test analytics integration');
console.log('calculateScoreBreakdown({role: "fullstack", experience: "senior", location: "hybrid", service: "enterprise"})');

// Auto-run complete test
console.log('\n🏁 Running complete test suite...');
runCompleteTest();

// Export functions for global use
window.recruitmentAPKTest = {
    runCompleteTest,
    simulateLiveSubmission,
    testWebhooks,
    testAnalytics,
    calculateScoreBreakdown,
    testScenarios
};

console.log('\n✨ Test suite loaded! Access all functions via window.recruitmentAPKTest');