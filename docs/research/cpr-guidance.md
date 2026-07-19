# Adult CPR Guidance for CPRWatch

Research date: 2026-07-19

## Scope

This note summarizes current adult basic life support guidance relevant to an Apple Watch/iPhone CPR timing assistant. It is product research, not a clinical protocol, certification course, or substitute for local emergency-dispatch instructions. Pediatric, neonatal, choking, drowning, traumatic arrest, pregnancy, opioid-associated emergencies, and advanced-life-support workflows need separate clinical review.

## Core adult CPR targets

- For an average adult in cardiac arrest, the 2025 American Heart Association (AHA) guideline recommends manual chest compressions at **100–120 per minute**.[^aha-bls]
- Compress the chest **at least 5 cm (2 in)** while avoiding excessive depth **greater than 6 cm (2.4 in)**.[^aha-bls]
- Allow **complete chest-wall recoil** between compressions; do not lean on the chest. Approximately equal compression and recoil times may be reasonable.[^aha-bls]
- Minimize interruptions. AHA describes a chest-compression fraction of **at least 60%** as a reasonable minimum, while high-performance teams may exceed 80%. Interruptions should be limited to interventions associated with improved outcomes.[^aha-bls]
- When two or more rescuers are available, switching compressors about **every 2 minutes** is reasonable because compression depth tends to decline after 90–120 seconds.[^aha-bls]
- Before an advanced airway, cycles of **30 compressions followed by 2 breaths** are reasonable for rescuers providing ventilations. Each breath should take about 1 second, produce visible chest rise, and avoid excessive ventilation.[^aha-bls]
- Resume compressions immediately after an AED shock and continue for about 2 minutes until the AED prompts another rhythm check.[^aha-healthcare-algorithm]

## Recognition, emergency activation, and AED flow

For a lay-rescuer experience, the app should preserve this priority order rather than opening directly into a metronome:

1. Confirm the scene is safe and check responsiveness and breathing. Cardiac arrest should be suspected when an adult is unresponsive and is not breathing normally or is only gasping. Lay rescuers should not be instructed to delay CPR for a pulse check.[^aha-bls]
2. Activate the **local emergency response system first**, preferably using a mobile phone on speaker, then immediately begin CPR with chest compressions. If another rescuer is present, have that person call and retrieve an AED.[^aha-bls]
3. Use the AED as soon as it is available and follow its prompts. Continue CPR until emergency professionals take over or the person shows signs of life.[^aha-healthcare-algorithm]

The emergency number and exact dispatcher flow vary by country. CPRWatch should localize this action and tell users to follow the emergency dispatcher and AED prompts; it should never present its timer as taking precedence over them.

## Trained and untrained users

- **All lay rescuers** should provide chest compressions for an adult with presumed cardiac arrest.[^aha-bls]
- For an **untrained rescuer**, or one unwilling or unable to give breaths, compression-only CPR is appropriate.[^aha-bls]
- A **trained rescuer** is encouraged to add breaths, normally using 30:2 cycles before an advanced airway.[^aha-bls]
- A health-care-professional workflow differs: professionals check breathing and pulse simultaneously for no more than 10 seconds and may need ventilation, rhythm, medication, and team-role prompts beyond a consumer app's safe scope.[^aha-healthcare-algorithm]

This supports separate, clearly labeled app modes rather than one ambiguous sequence: a minimal lay-rescuer emergency flow and a clinician/training flow developed and validated with resuscitation specialists.

## Implications for the first CPRWatch version

### Appropriate timing-assistant behavior

- Start with a prominent **call emergency services / use speakerphone** action and a short recognition prompt.
- Provide an audible and haptic cadence within the 100–120/min range. A fixed default such as 110/min is a product choice inside the guideline range, not itself a clinical recommendation.
- Count sets of 30 only when the user selects a breaths-enabled mode; make the two-breath pause brief and obvious.
- Provide a two-minute cycle/switch-rescuer cue, while allowing AED prompts or professional instructions to interrupt it.
- Keep the CPR screen operable without network connectivity and resilient to screen dimming, app suspension, and loss of phone/watch connectivity.
- Use large controls, minimal reading, high contrast, voice/haptic cues, and no setup steps during the emergency.

The AHA says real-time audiovisual feedback devices are reasonable for optimizing CPR, but this does **not** establish that an unvalidated watch algorithm accurately measures compression depth, recoil, hand position, or patient outcome.[^aha-bls] The safest initial claim is therefore **cadence and sequence assistance**, not measurement of CPR quality.

### Safety boundaries

- Do not claim that Apple Watch motion sensors measure chest-compression depth or recoil unless the full measurement method and accuracy have been clinically validated on the intended users and conditions.
- Do not let the timer delay emergency activation, AED application, dispatcher instructions, or transfer to professionals.
- Do not imply the app detects cardiac arrest, guarantees correct CPR, replaces training, or improves survival unless evidence specifically supports the claim.
- Include versioned clinical content, named clinical reviewers, source/guideline dates, localization review, accessibility testing, on-device failure testing, and a rapid correction process.
- Clearly identify whether the product is for training, emergency assistance, professional use, or some combination. Intended use, claims, users, and markets determine the regulatory analysis.

## Apple review, privacy, and regulatory considerations

Apple applies greater scrutiny to medical apps that could provide inaccurate information or be used in diagnosis or treatment. Accuracy claims must disclose supporting data and methodology; Apple may reject claims that cannot be validated. Apple also says medical apps should remind users to consult a doctor before making medical decisions and asks developers to provide regulatory-clearance documentation when applicable.[^apple-review]

Apple requires apps categorized as Medical or Health & Fitness (or with frequent medical/treatment information) to declare regulated-medical-device status for the EU/EEA, UK, and US. Regulated apps may need authorization/registration details, intended-use text, instructions for use, and safety information.[^apple-device-status]

The app's regulatory status cannot be decided from the concept alone. Before public distribution, obtain qualified regulatory advice for every target market, based on the final intended use and claims. A real-time tool intended to guide treatment during an actual cardiac arrest creates materially different safety and regulatory risk from a metronome used only in manikin training.

If CPRWatch collects HealthKit, motion, location, emergency-contact, or session data, minimize collection and define a clear purpose. Apple's rules prohibit using health/fitness data for advertising or unrelated data mining, require disclosure of the specific health data collected, prohibit writing false data into HealthKit, and prohibit storing personal health information in iCloud.[^apple-review]

## Decisions requiring clinical/product confirmation

1. Is version 1 strictly a **training aid**, or is it intended for use in a real emergency?
2. Is the primary user an untrained bystander, a CPR-trained layperson, or a health professional?
3. Which countries will launch first, and what local emergency numbers and resuscitation guidelines apply?
4. Will the app only pace compressions, or claim to detect/count/grade them?
5. Who is the accountable clinical reviewer, and what validation and risk-management process will be used?

## Primary sources

[^aha-bls]: American Heart Association, [2025 Guidelines, Part 7: Adult Basic Life Support](https://cpr.heart.org/en/resuscitation-science/cpr-and-ecc-guidelines/adult-basic-life-support).
[^aha-healthcare-algorithm]: American Heart Association, [2025 Adult Basic Life Support Algorithm for Health Care Professionals](https://cpr.heart.org/-/media/CPR-Files/CPR-Guidelines-Files/2025-Algorithms/Algorithm-BLS-Adult-Healthcare-250701.pdf?sc_lang=en).
[^apple-review]: Apple, [App Review Guidelines, sections 1.4.1 and 5.1](https://developer.apple.com/app-store/review/guidelines/).
[^apple-device-status]: Apple, [Declare regulated medical device status](https://developer.apple.com/help/app-store-connect/manage-app-information/declare-regulated-medical-device-status).
