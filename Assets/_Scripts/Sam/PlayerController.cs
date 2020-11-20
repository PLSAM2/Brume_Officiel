using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static CirclePreview;
using static SquarePreview;

public class PlayerController : MonoBehaviour
{
    [SerializeField] Animator myAnimator;

    [SerializeField] CharacterController myCharac;

    private Vector3 inputRotation;
    private Vector3 mousePlacement;
    private Vector3 screenCentre;

    [SerializeField] float speed = 2;

    //attack
    [SerializeField] bool blockMovement = false;
    [SerializeField] bool blockRotation = false;

    bool isChargeAttack = false;

    [SerializeField] GameObject prefabHit;

    public enum typePreview
    {
        shape,
        square,
        circle,
        arrow
    }

    public typePreview currentPrev;

    [Header("shape")]
    [SerializeField] ShapePreview myShapePreview;
    [SerializeField] float range = 2;
    [SerializeField] float angle = 50;
    [SerializeField] float rotation = 0;
    [SerializeField] Vector3 pos;

    [Header("square")]
    [SerializeField] SquarePreview mySquarePreview;
    [SerializeField] float lenghtSq = 6;
    [SerializeField] float widthSq = 1;
    [SerializeField] float rotationSq = 0;
    [SerializeField] squareCenter centerSq = squareCenter.border;
    [SerializeField] Vector3 posSq;

    [Header("circle")]
    [SerializeField] CirclePreview myCirclePreview;
    [SerializeField] float raduis = 6;
    [SerializeField] float rotationCircle = 0;
    [SerializeField] circleCenter centerCircle = circleCenter.border;
    [SerializeField] Vector3 posCircle;

    [Header("arrow")]
    [SerializeField] ArrowPreview myArrowPreview;
    [SerializeField] Vector3 posEndArr;

    void Update()
    {
        Vector3 forward = transform.TransformDirection(Vector3.forward) * 10;

        Debug.DrawRay(transform.position, forward, Color.red);

        //rotation
        FindCrap();
        if (!blockRotation)
        {
            transform.rotation = Quaternion.LookRotation(inputRotation);
        }

        Movement();


        //attack
        if (Input.GetMouseButton(0))
        {
            //show preview
            isChargeAttack = true;
            AttackPreview(true);
        }

        if (Input.GetMouseButtonUp(0) && isChargeAttack)
        {
            //show preview
            isChargeAttack = false;
            AttackPreview(false);

            Attack();
        }
    }

    void Attack()
    {
        blockMovement = true;
        blockRotation = true;

        myAnimator.SetTrigger("Attack");

        StartCoroutine(WaitAttack());
    }

    void MakeDamage()
    {
        Collider[] objTouch = Physics.OverlapSphere(transform.position, range);

        foreach (Collider col in objTouch)
        {
            if (col.gameObject.layer != 31) { continue; }

            Vector3 dir = (col.gameObject.transform.position - transform.position).normalized;

            float angleBetweenGuardAndPlayer = Vector3.Angle(transform.forward, dir);

            if (angleBetweenGuardAndPlayer <= angle)
            {
                Debug.Log(col.gameObject + "touched");
                col.gameObject.GetComponent<EnemySam>().GetDamage(10);
            }
        }
    }

    IEnumerator WaitAttack()
    {
        yield return new WaitForSeconds(0.5f);
        MakeDamage();

        yield return new WaitForSeconds(0.55f);
        blockMovement = false;
        blockRotation = false;
    }

    void AttackPreview(bool _show)
    {
        switch (currentPrev)
        {
            case typePreview.shape:
                if (_show)
                {
                    if (myShapePreview == null)
                    {
                        myShapePreview = PreviewManager.Instance.GetShapePreview(transform);
                    }
                    myShapePreview.Init(range, angle, rotation, pos);
                }

                myShapePreview.gameObject.SetActive(_show);
                break;

            case typePreview.square:
                if (_show)
                {
                    if (mySquarePreview == null)
                    {
                        mySquarePreview = PreviewManager.Instance.GetSquarePreview(transform);
                    }
                    mySquarePreview.Init(lenghtSq, widthSq, rotationSq, centerSq, posSq);
                }

                mySquarePreview.gameObject.SetActive(_show);
                break;

            case typePreview.circle:
                if (_show)
                {
                    if (myCirclePreview == null)
                    {
                        myCirclePreview = PreviewManager.Instance.GetCirclePreview(transform);
                    }
                    myCirclePreview.Init(raduis, rotationSq, centerCircle, posCircle);
                }

                myCirclePreview.gameObject.SetActive(_show);
                break;

            case typePreview.arrow:
                if (_show)
                {
                    if (myArrowPreview == null)
                    {
                        myArrowPreview = PreviewManager.Instance.GetArrowPreview();
                    }
                    myArrowPreview.Init(transform.position, posEndArr);
                }

                myArrowPreview.gameObject.SetActive(_show);
                break;
        }
    }

    void Movement()
    {
        if (!blockMovement)
        {
            //input movement
            Vector3 _directionInputed = new Vector3(Input.GetAxisRaw("Horizontal"), 0, Input.GetAxisRaw("Vertical"));

            //deplacement
            myCharac.Move(_directionInputed * speed * Time.deltaTime);

            //animation
            float right = Vector3.Dot(transform.right, _directionInputed);
            float forward = Vector3.Dot(transform.forward, _directionInputed);

            if (myAnimator.GetFloat("Forward") != forward || myAnimator.GetFloat("Turn") != right)
            {
                myAnimator.SetFloat("Forward", forward);
                myAnimator.SetFloat("Turn", right);
            }
        }
    }

    void FindCrap()
    {
        screenCentre = new Vector3(Screen.width * 0.5f, 0, Screen.height * 0.5f);
        mousePlacement = Input.mousePosition;
        mousePlacement.z = mousePlacement.y;
        mousePlacement.y = 0;
        inputRotation = mousePlacement - screenCentre;
    }
}
