def test_read_root(client):
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "message" in data


def test_health_check(client):
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["database"] == "connected"


def test_get_items_empty(client):
    response = client.get("/api/items")
    assert response.status_code == 200
    assert response.json() == []


def test_create_item(client):
    payload = {
        "title": "First Item",
        "description": "DevOps test item description",
    }
    response = client.post("/api/items", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == payload["title"]
    assert data["description"] == payload["description"]
    assert "id" in data
    assert "created_at" in data


def test_list_items_after_creation(client):
    client.post("/api/items", json={"title": "Item 1", "description": "Desc 1"})
    client.post("/api/items", json={"title": "Item 2", "description": "Desc 2"})

    response = client.get("/api/items")
    assert response.status_code == 200
    items = response.json()
    assert len(items) == 2
    assert items[0]["title"] == "Item 1"
    assert items[1]["title"] == "Item 2"
