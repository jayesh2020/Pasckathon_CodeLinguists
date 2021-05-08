import React from 'react'

const Signin = (props) => {
    const handlePatient = (e) => {
        e.preventDefault();
        props.history.push('/login/patient');
    }
    const handleDoctor = (e) => {
        e.preventDefault();
        props.history.push('/login/doctor');
    }
    return (
        <div>
            Login as
            <div className="row">
                <button onClick={handlePatient}>Patient</button>
                <button onClick={handleDoctor}>Doctor</button>
            </div>
        </div>
    )
}

export default Signin;