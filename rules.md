# Rules

### ■ Naming

최대한 개발 언어(Java, Javascript, Python, SQL 등)에 사용되는 예약어(class, select, sequence 등)는 피한다

- Email

- Project Name

    Prefix: seung
    
    Delimiter: Hyphen ```-```
    
    Suffix: [here](https://en.wikipedia.org/wiki/List_of_Korean_dishes)
    
    ```
    e.g. seung-ramyeon
    ```
    
    <details>
      <summary>Accordion</summary>
        
        Contents
        
        - List
        - List
        
    </details>

- Database

  > 최대한 모든 개발 언어에 사용되는 예약어(class, select, sequence 등)는 단일사용을 피한다.
  
  - Prefix
  
    Table: t_*
    
    View: v_*
    
    Function: f_*
    
    Procedure: p_*
    
    Reserved Columns Name
    
    - date_inst: 등록일시
    - date_updt: 수정일시
    - is_active: 사용구분 - 0: 미사용, 1: 사용
    - is_lock: 사용구분 - 0: 사용, 1: 잠금
    - trace_id: 추적아이디
    - item_no: 아이템번호

- Java

- Python

- Javascript

- Flutter

### ■ Coding

- Java

  - Secure coding [here](https://wiki.wikisecurity.net/guide:java_%EA%B0%9C%EB%B0%9C_%EB%B3%B4%EC%95%88_%EA%B0%80%EC%9D%B4%EB%93%9C)

- Python

- Javascript

- Flutter

### ■ Volume

  - Windows
  
    ```bash
    /
    ├── C: OS
    ├── ?: One Drive
    ├── W: WorkSpace
    │   ├── apps: Local App Build Destination
    │   ├── logs: Log Files
    │   ├── seung-git: KESG Git Local Repository
    │   ├── seung-secret: KESG Server Certification, AWS PEM Keys..
    │   └── sts: STS Application
    └── N: NAS
    ```

###### Mac

- Dev

- Git

- NAS

- One Drive

### ■ Password

  - Regex Expression [here](https://regexr.com/7jvub)
  
    ```
    ^(?!.* )(?=.*[a-zA-Z])(?=.*\d)(?=.*\W).{8,16}$
    ```
