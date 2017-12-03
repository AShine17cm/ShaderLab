using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Mg.Tut.DX
{
    public class DxMotion : MonoBehaviour
    {
        public Transform tz1, tz2;
        public Transform tx;
        public float spd = 1f;
        public float period = 3f;
        public float timer = 0;
        public float k = 1f;
        // Use this for initialization
        void Start()
        {
            timer = period / 2f;
        }

        // Update is called once per frame
        void Update()
        {
            tz1.position += Vector3.forward * spd * Time.deltaTime * k;
            tz2.position -= Vector3.forward * spd * Time.deltaTime * k;
            tx.position += Vector3.right * spd * Time.deltaTime * k;
            timer = timer + Time.deltaTime;
            if (timer > period)
            {
                timer = 0;
                k = k * (-1f);
            }
        }
    }
}
