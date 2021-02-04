-- We need to update the levels table to unpublish any Mock Exam levels 
-- Note that Mock Exam levels are generally are available per each subject in each channel (one per subject)
-- Also note that all unpublished levels (including Mock Exam levels) will show for Admin and Provider views.  They will only be hidden from Student view.

UPDATE level SET published = false WHERE UPPER(name) like '%MOCK%';


