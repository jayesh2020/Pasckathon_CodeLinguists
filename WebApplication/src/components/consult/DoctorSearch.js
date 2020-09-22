import React,{ useState,useEffect } from 'react'
import { connect } from 'react-redux';
import { Redirect } from 'react-router-dom';
import { getDoctors } from '../../actions/doctorSearch';
import { Link } from 'react-router-dom';

const DoctorSearch = ({ auth, doctorSearch, getDoctors }) => {
    useEffect(() => {
        getDoctors(auth.uid);
    },[]);
    return (
        <div>
            {doctorSearch.doctors && doctorSearch.doctors.map(doctor => (
                <div key={doctor.email}>
                    <h5>{doctor.name}</h5>
                    <p>{doctor.clinicAddress}</p>
                    <img src={doctor.profilePic} />
                    <p>{doctor.phoneNumber}</p>
                    <p>{doctor.email}</p>
                    <Link to={`/doctor/consult/${doctor.id}`}>Consult</Link>
                </div>
            ))}
        </div>
    )
}

const mapStateToProps = (state) => ({
    auth: state.auth,
    doctorSearch: state.doctorSearch
});

const mapDispatchToProps = (dispatch) => ({
    getDoctors: (uid) => dispatch(getDoctors(uid))
});

export default connect(mapStateToProps,mapDispatchToProps)(DoctorSearch);
