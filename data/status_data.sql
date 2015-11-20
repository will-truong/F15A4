INSERT INTO F15A4_status(status_type, description) VALUES('Entered', 'The RFE has been created but has not yet been submitted for approval.');
INSERT INTO F15A4_status(status_type, description) VALUES('Submitted', 'The RFE has been submitted to the Lab System Administrator for approval.');
INSERT INTO F15A4_status(status_type, description) VALUES('Returned', 'The RFE has been returned for further information or clarification. Once submitted again, it will follow the same routing as an Entered RFE.');
INSERT INTO F15A4_status(status_type, description) VALUES('Recalled', 'The requestor has recalled an RFE that has not yet reached final approval. Once submitted again, it will follow the same routing as an Entered RFE.');
INSERT INTO F15A4_status(status_type, description) VALUES('Rejected', 'The RFE has been rejected and cannot be implemented.');
INSERT INTO F15A4_status(status_type, description) VALUES('SA Approved', 'The Lab System Administrator has approved the RFE; it has been submitted for Lab Director approval.');
INSERT INTO F15A4_status(status_type, description) VALUES('LD Approved', 'The Lab Director has approved the RFE; it has been submitted for Network Security Panel approval.');
INSERT INTO F15A4_status(status_type, description) VALUES('CH Approved', 'The Lab Director has approved the RFE; it has been submitted to the Chairperson of Security Panel approval.');
INSERT INTO F15A4_status(status_type, description) VALUES('Final Approved', 'The Executive Directors Office has given final approval for the RFE and it may be implemented.');