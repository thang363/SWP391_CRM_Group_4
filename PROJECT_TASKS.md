# PROJECT TASKS - Landing Page Feature Implementation

## ✅ COMPLETED TASKS (Phase 1-3)

### Phase 1: Database & Core Logic
- [x] Analyze Business Logic & Workflow (Assignment, State Transitions)
- [x] Design Database Schema (`LandingPages`, `LandingPageSubmissions`)
- [x] Create SQL Script to fix/update Schema
- [x] Create Entity Classes: `LandingPage.java`, `LandingPageSubmission.java`
- [x] Update ViewModels: `CampaignViewModel.java`, `LandingPageViewModel.java`

### Phase 2: Backend Logic (Service & DAO)
- [x] Create `LandingPageDAO` & `LandingPageDAOImpl` (using `DatabaseUtil`)
- [x] Create `LandingPageService` & `LandingPageServiceImpl`
- [x] Update `CampaignServlet` to fetch LP data and handle Assignment
- [x] Implement Mock Data for LP Templates

### Phase 3: Frontend (Manager Assignment)
- [x] Add "Assign" button to `campaigns.jsp` table
- [x] Create "Assign Modal" in `campaigns.jsp`
- [x] Implement AJAX logic in `campaigns.js` for Assignment
- [x] Handle edge cases (Re-assignment, Status display)

---

## 🚀 UPCOMING TASKS (Phase 4-6)

### Phase 4: Landing Page Builder (Marketing Staff)
- [ ] **Create Landing Page Workspace**
    - [ ] Create `LandingPageController` (Servlet) for handling builder actions
    - [ ] Create `builder.jsp` view for Marketing Staff
    - [ ] Implement WYSIWYG Editor or Form-based builder (depending on requirements)
    - [ ] Add "Save Draft" functionality (AJAX)
    - [ ] Add "Preview" functionality
- [ ] **Submission Logic**
    - [ ] Implement "Submit for Approval" action
    - [ ] Validate required content before submission

### Phase 5: Public View & Lead Capture
- [ ] **Public Servlet**
    - [ ] Create `PublicLandingPageServlet` to handle `/lp/{id}` requests
    - [ ] Implement checks for LP Status (must be `Active` to view)
    - [ ] Render HTML content dynamically based on `data_config`
- [ ] **Lead Handling**
    - [ ] Handle Form Submissions (POST) from public LPs
    - [ ] Save data to `LandingPageSubmissions` via Service/DAO
    - [ ] Implement "Thank You" page or redirect

### Phase 6: Manager Review & Reporting
- [ ] **Review Interface**
    - [ ] Add "Review" button for Managers on Pending LPs
    - [ ] Create `review.jsp` or modal for approving/rejecting LPs
    - [ ] Implement "Approve" (Active) and "Reject" (Draft) logic
- [ ] **Reporting**
    - [ ] Create UI to view Lead Submissions
    - [ ] Add "Export to Excel" for Leads
    - [ ] Visualize simple metrics (Views, Conversions)
