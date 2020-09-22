import React,{ useState, useEffect } from 'react';
import Questionaire from './Questionaire';
import { connect } from 'react-redux';
import { getDoctors, getDoctor } from '../../actions/doctorSearch';

const DoctorConsult = ({match, getDoctor, doctorSearch}) => {
    const [toggler,setToggler] = useState(false);
    useEffect(() => {
        const uid = match.uid;
        console.log(uid);
        getDoctor(uid);
    },[]);
    const { selectedDoctor } = doctorSearch;
    return (
        <div>
            {toggler && <Questionaire />}
            {selectedDoctor && <div>
                <img src={selectedDoctor.profilePic} />
                <p>{selectedDoctor.name}</p>
            </div>}
        </div>
    )
}

const mapStateToProps = (state) => ({
    doctorSearch: state.doctorSearch
});

const mapDispatchToProps = (dispatch) => ({
    getDoctor: (uid) => dispatch(getDoctor(uid))
});

export default connect(mapStateToProps,mapDispatchToProps)(DoctorConsult);
