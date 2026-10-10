# POST Payload Fields for Join as Staff

When submitting a staff application through the "Join Eldoria" flow, the following fields are included in the POST payload:

## Personal Information
- `name`: Full name (as on ID)
- `phone`: 10-digit mobile number (without +91 prefix)
- `email`: Email address (optional)
- `dob`: Date of birth (YYYY-MM-DD format)
- `gender`: Gender (Female/Male/Other)
- `city`: City ID (e.g., 'mumbai', 'thane')
- `area`: Area/locality
- `address`: Full residential address

## Professional Information
- `role`: Role applying for (from predefined list)
- `qualification`: Highest qualification
- `regNo`: Council registration number (optional)
- `experience`: Years of experience (numeric)
- `skills`: List of skills (multi-select from predefined list)
- `languages`: List of languages (multi-select from predefined list)
- `availability`: List of availabilities (multi-select from predefined list)

## Emergency Contact
- `emergencyName`: Emergency contact name
- `emergencyPhone`: Emergency contact phone (10-digit number)
- `emergencyRelation`: Relationship to emergency contact

## Documents
- `files`: Map of uploaded documents with metadata (name, size, path, type)
  - Keys correspond to document types: 'photo', 'idProof', 'qualification', 'experience', 'police'

## Application Status Fields
- `applied`: Always set to `true`
- `approval`: Set to `'pending'` for new applications
- `docs`: Set to `'pending'` for new applications
- `onDuty`: Set to `false` for new applications
- `submittedAt`: Timestamp of submission (milliseconds since epoch)
- `appHistory`: Array containing history entry with:
  - `status`: `'pending'`
  - `at`: Timestamp
  - `by`: `'applicant'`
  - `note`: `'Application submitted'` or `'Application resubmitted with updates'`

## System-Generated Fields
- `id`: Unique identifier (either provided for updates or generated as 'app_<timestamp>')

## Validation Notes
All fields are validated before submission:
- Name: Required
- Phone: Must be exactly 10 digits
- DOB: Required and must result in age between 18-70
- Gender: Required
- Area: Required
- Address: Required
- Role: Required
- Qualification: Required
- Experience: Must be between 0-50
- Skills: At least one required
- Languages: At least one required
- Availability: At least one required
- Emergency contact name: Required
- Emergency contact phone: Must be exactly 10 digits
- Required documents: Photo, ID proof, and qualification documents are mandatory

## Example Payload Structure
```json
{
  "id": "app_1234567890",
  "name": "Sunita Ramesh Patil",
  "phone": "9876543210",
  "email": "sunita@example.com",
  "dob": "1996-08-14",
  "gender": "Female",
  "city": "mumbai",
  "area": "Andheri East",
  "address": "Room 14, Sai Krupa Chawl, Marol, Andheri East, Mumbai 400059",
  "qualification": "GNM Nursing, 2018",
  "regNo": "MNC-204511",
  "experience": 6,
  "skills": ["Elder care", "Injections & IV", "Wound dressing"],
  "languages": ["Hindi", "Marathi", "English"],
  "availability": ["Day visits", "12-hr shifts"],
  "emergencyName": "Sunil Sawant",
  "emergencyPhone": "9811100011",
  "emergencyRelation": "Father",
  "files": {
    "photo": {"name": "photo.jpg", "size": 102400, "path": "/path/to/photo.jpg", "type": "image/jpeg"},
    "idProof": {"name": "aadhaar.pdf", "size": 204800, "path": "/path/to/aadhaar.pdf", "type": "application/pdf"},
    "qualification": {"name": "gnm_certificate.pdf", "size": 512000, "path": "/path/to/gnm_certificate.pdf", "type": "application/pdf"}
  },
  "applied": true,
  "approval": "pending",
  "docs": "pending",
  "onDuty": false,
  "submittedAt": 1728547200000,
  "appHistory": [
    {
      "status": "pending",
      "at": 1728547200000,
      "by": "applicant",
      "note": "Application submitted"
    }
  ]
}
```