import React,{ Fragment, useRef } from 'react';
import { connect } from 'react-redux';

const Report = ({report}) => {
    var medic;
    return (
        <div>
            {report && 
                <div>
                <h3 style={{color:"#ff9800", fontWeight:1000}}>DERMOSOLUTIONS</h3>
                <div className="row">
                    <div className="col-sm-2"></div>
                    <div className="col-sm-4">
                        <h5 style={{color: "ff9800",fontWeight:1000}}>Personal Information</h5>
                        <h6>Name: {report.patientName}</h6>
                        <h6>Gender: {report.gender}</h6>
                        <h6>Address: {report.city}</h6>
                    </div>
                    <div className="col-sm-4">
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Contact Information</h5>
                    <h6>Email: {report.patientEmail}</h6>
                    <h6>Phone Number: {report.patientNumber}</h6>
                    </div>
                <div className="col-sm-2"></div>

                </div>
                <div>
                    
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Medical Information</h5>
                    <h6>Height: {report.patientHeight}</h6>
                    <h6>Weight: {report.patientWeight}</h6>
                    <h6>Blood Group: {report.bloodGroup}</h6>
                    
                </div>
                
                
                <div>
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Infection Details</h5>
                    <h6>Start Date: {report.duration}</h6>
                    <h6>Severity(out of 5): {report.severity}</h6>
                    <h6>Previous Medications: {report.prevMed}</h6>
                    <h6>Body Part Infected: {report.bodyPart}</h6>
                    <h6>Pain during : {report.timeOfDay}</h6>
                </div>
                <div>
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Model Predictions</h5>
                    <h6>Disease Name: {report.diseasePrediction}</h6>
                    <h6>Disease Image</h6>
                    <img src={report.diseaseUrl} height="40%" width="40%" />
                </div>
                {report.medications && <div>
                    <h5 style={{color: "ff9800",fontWeight:1000}}>Doctor Report</h5>
                    {report.doctorDiseaseName&&<h6>Disease Name: {report.doctorDiseaseName}</h6>}
                    <h6>Medications:</h6>
                    {report.medications && report.medications.map(med => (
                        medic = med.split(","),
                        <p>{medic[0]}: {medic[1]}</p>
                    ))}
                    <h6>Medicine Duration: {report.medicineDuration} days</h6>
                    {report.otherInfo && <h6>Other Info: {report.otherInfo}</h6>}
                    </div>}
                    <div className="divider"></div>
                   
            </div>}
            {report.hi && <div>
                <h5 style={{color: "ff9800",fontWeight:1000}}>Medical History</h5>
                {report.hi.map(h => <div>
                        <p>Doctor Name: {h.doctor}</p>
                        <p>Symtoms: {h.symptoms}</p>
                        <p>Medicines: {h.medicines}</p>
                    </div>)}
                </div>}
        </div>
    )

}

const mapStateToProps = state => ({
    doctorSearch: state.doctorSearch
})

export default connect(mapStateToProps)(Report);
